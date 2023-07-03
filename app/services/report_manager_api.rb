# frozen_string_literal: true

# Encapsulates the HTTP API for the report manager
class ReportManagerApi # rubocop:disable Metrics/ClassLength
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

    if ok?(response)
      record_api_ok_response(http_url, 'POST', response, start_time)
      load_status_report(response)
    else
      record_api_error_response(http_url, 'POST', response, start_time)
    end
  end

  def get(http_url, options = {})
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    response = get_from_api(http_url, options)

    if ok?(response)
      record_api_ok_response(http_url, 'GET', response, start_time)
      response.body
    else
      record_api_error_response(http_url, 'GET', response, start_time)
    end
  end

  private

  def get_from_api(http_url, options) # rubocop:disable Metrics/MethodLength
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
      faraday.request  :url_encoded
      faraday.use      FaradayMiddleware::FollowRedirects
      faraday.adapter :net_http
    end
  end

  def set_connection_timeout(conn) # rubocop:disable Naming/AccessorMethodName
    conn.options[:timeout] = 600
    conn
  end

  def ok?(response)
    (200..207).cover?(response.status)
  end

  def as_http_api(api)
    api.start_with?('http:') ? api : "#{url}#{api}"
  end

  def parser
    @parser ||= Yajl::Parser.new
  end

  def report_json_failure(_json)
    msg = 'JSON result was not parsed correctly'
    Sentry.capture_message(msg)
    Rails.logger.error(msg)
    throw msg
  end

  def record_api_error_response(http_url, method, response, start_time)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    ellapsed_time = end_time - start_time
    log_api_response(response, start_time, url: http_url, message: "API #{method}")
    instrumenter&.instrument('response.api', response: response, duration: ellapsed_time)

    throw "API #{method} to '#{http_url}' failed: #{response.status} '#{response.body}'"
  end

  def record_api_ok_response(http_url, method, response, start_time)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    ellapsed_time = end_time - start_time
    log_api_response(response, start_time, url: http_url, message: "API #{method}")
    instrumenter&.instrument('response.api', response: response, duration: ellapsed_time)
  end

  def record_failed_connection(http_url, exception)
    instrumenter&.instrument('connection_failure.api', exception: exception, url: http_url)
    throw "Failed to connect to '#{http_url}'"
  end

  def log_api_response(response, start_time, url: nil, status: nil, message: '')
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    ellapsed_time = end_time - start_time
    Rails.logger.info(
      url: response ? response.env[:url].to_s : url,
      status: status || response.status,
      duration: ellapsed_time,
      message: message
    )
  end
end
