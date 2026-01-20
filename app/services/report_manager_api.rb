# frozen_string_literal: true

# Encapsulates the HTTP API for the report manager
class ReportManagerApi
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
      req.headers['Accept'] = options.delete(:accept) || 'application/json'
      req.params.merge! options
    end
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
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
  def parse_json(json)
    result = nil
    jsonified = json.is_a?(String) ? json : json.to_json
    json_hash = parser.parse(jsonified) do |json_chunk|
      if result
        result = [ result ] unless Array(result)
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
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
    record_failed_connection(http_url, e)
  end

  def create_http_connection(http_url, auth = false)
    retry_options = {
      max: 2,
      interval: 0.05,
      interval_randomness: 0.5,
      backoff_factor: 2,
      exceptions: [ Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::ResourceNotFound ],
    }

    Faraday.new(url: http_url) do |config|
      config.use Faraday::Request::UrlEncoded
      config.use Faraday::FollowRedirects::Middleware

      config.request :authorization, :basic, api_user, api_pw if auth
      # instrument the request to log the time it takes to complete
      config.request :instrumentation, name: 'requests.api'
      config.request :retry, retry_options

      config.response :json
      # be sure to raise exceptions on 40x, 50x responses
      config.response :raise_error
    end
  end

  def set_connection_timeout(conn)
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
    Sentry.capture_message(msg) if Rails.env.production?
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

    Sentry.capture_message(message) if Rails.env.production?
    Sentry.capture_exception(response) if Rails.env.production?
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

  def record_failed_connection(http_url, exception)
    message = "Failed to connect to API at #{http_url} due to: #{exception}"
    Sentry.capture_message(message) if Rails.env.production?
    Sentry.capture_exception(exception) if Rails.env.production?
    Log.error(message, exception)
    instrumenter&.instrument('connection_failure.api', exception:)
  end
end
