# frozen_string_literal: true

# Encapsulates the HTTP API for the report manager
class ReportManagerApi # rubocop:disable Metrics/ClassLength
  include Log

  attr_reader :instrumenter

  def initialize(instrumenter = ActiveSupport::Notifications)
    @instrumenter = instrumenter
  end

  # Get parsed JSON from the given URL
  def get_json(http_url, options)
    parse_json(get(http_url, options))
  end

  def post_json(http_url, options, json = nil)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    response = post_to_api(http_url, options, json)

    if ok?(response, http_url)
      record_api_ok_response(http_url, 'POST', response, start_time)
      load_status_report(response)
    else
      record_api_error_response(http_url, 'POST', response, start_time)
    end
  end

  def get(http_url, options = {})
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    response = get_from_api(http_url, options)

    if ok?(response, http_url)
      record_api_ok_response(http_url, 'GET', response, start_time)
      response.body
    else
      record_api_error_response(http_url, 'GET', response, start_time)
    end
  end

  private

  def get_from_api(http_url, options)
    conn = set_connection_timeout(create_http_connection(http_url))

    conn.get do |req|
      req.headers['X-Request-ID'] = Thread.current[:request_id] if Thread.current[:request_id]
      req.headers['Accept'] = if (accept = options.delete(:accept))
                                accept
                              else
                                'application/json'
                              end
      req.params.merge! options
    end
  rescue Faraday::ConnectionFailed => e
    record_failed_connection(http_url, e)
  end

  def load_status_report(response)
    if response.status == 201
      get_json(response.headers[:location], {})
    else
      {}
    end
  end

  # Parse the given JSON string into a data structure. Throws an exception if
  # parsing fails
  def parse_json(json) # rubocop:disable Metrics/MethodLength
    result = nil

    json_hash = parser.parse(StringIO.new(json)) do |json_chunk|
      if result
        result = [result] unless result.is_a?(Array)
        result << json_chunk
      else
        result = json_chunk
      end
    end

    report_json_failure(json) unless result || json_hash
    result || json_hash
  end

  def post_to_api(http_url, options, json)
    conn = set_connection_timeout(create_http_connection(http_url))

    conn.post do |req|
      req.headers['X-Request-ID'] = Thread.current[:request_id] if Thread.current[:request_id]
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.params.merge!(options)
      req.body = json if json
    end
  rescue Faraday::ConnectionFailed => e
    record_failed_connection(http_url, e)
  end

  def create_http_connection(http_url)
    Faraday.new(url: http_url) do |faraday|
      faraday.use Faraday::Request::UrlEncoded
      faraday.use Faraday::Request::Retry
      faraday.use FaradayMiddleware::FollowRedirects
      # instrument the request to log the time it takes to complete
      faraday.request :instrumentation, name: 'requests.api'
      # be sure to raise exceptions on 40x, 50x responses
      faraday.response :raise_error
      # setting the adapter must be the final step, otherwise get a warning from Faraday
      faraday.adapter(:net_http)
    end
  end

  def set_connection_timeout(conn) # rubocop:disable Naming/AccessorMethodName
    conn.options[:timeout] = 600
    conn
  end

  def ok?(response, http_url)
    unless (200..207).cover?(response.status)
      response_body = JSON.parse(response.body, symbolize_names: true)
      response_message = response_body[:message]
      response_error = response_body[:error]
      msg = "#{response_error}: #{response_message}"

      raise ServiceException.new(msg, response.status, http_url, response.body)
    end

    true
  end

  def as_http_api(api)
    Log.debug { "API: #{api}, URL: #{url.to_json}" } if Rails.env.development?
    uri = URI.parse(api)
    uri.scheme ? api : "#{url}#{api}"
  end

  def parser
    @parser ||= Yajl::Parser.new
  end

  def report_json_failure(json)
    msg = "Failed to parse JSON: #{json.inspect}"
    Sentry.capture_message(msg)
    Log.error(msg)
  end

  def record_api_error_response(http_url, method, response, start_time)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    ellapsed_time = (end_time - start_time) / 1000 # convert to milliseconds
    log_fields = { method: method, response_time: ellapsed_time, url: http_url }
    message = "API #{method} to '#{http_url}' failed"

    if response
      message += response.body.to_json if response.body.present?
      log_fields[:status] = response.status
    end
    Log.error(message, log_fields, 'error')
    instrumenter&.instrument('service_exception.api', response:, duration: ellapsed_time)
  end

  def record_api_ok_response(http_url, method, response, start_time)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    ellapsed_time = (end_time - start_time) / 1000 # convert to milliseconds
    log_fields = { method: method, response_time: ellapsed_time, url: http_url }
    message = "API #{method} request to '#{http_url}' succeeded"

    log_fields[:status] = response.status if response

    Log.info(message, log_fields)
    instrumenter&.instrument('response.api', response:, duration: ellapsed_time)
  end

  def record_failed_connection(exception, http_url)
    Log.error("Failed to connect to API at #{http_url} due to: #{exception}", exception)
    instrumenter&.instrument('connection_failure.api', exception:)
  end
end
