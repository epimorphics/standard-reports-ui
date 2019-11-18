# frozen_string_literal: true

# Encapsulates the HTTP API for the report manager
class ReportManagerApi
  # Get parsed JSON from the given URL
  def get_json(http_url, options)
    parse_json(get(http_url, options))
  end

  def post_json(http_url, options, json = nil)
    response = post_to_api(http_url, options, json)
    if ok?(response)
      load_status_report(response)
    else
      throw "API POST to '#{http_url}' failed: #{response.status} '#{response.body}'"
    end
  end

  def get(http_url, options = {})
    response = get_from_api(http_url, options)
    if ok?(response)
      response.body
    else
      throw "API GET from '#{http_url}' failed #{response.status} '#{response.body}'"
    end
  end

  private

  def get_from_api(http_url, options) # rubocop:disable Metrics/MethodLength
    conn = set_connection_timeout(create_http_connection(http_url))

    response = conn.get do |req|
      req.headers['Accept'] = if (accept = options.delete(:accept))
                                accept
                              else
                                'application/json'
                              end
      req.params.merge! options
    end

    raise "Failed to read from #{http_url}: #{response.status.inspect}" unless ok?(response)

    response
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

    response = conn.post do |req|
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.params.merge!(options)
      req.body = json if json
    end

    raise "Failed to post to #{http_url}: #{response.status.inspect}" unless ok?(response)

    response
  end

  def create_http_connection(http_url)
    Faraday.new(url: http_url) do |faraday|
      faraday.request  :url_encoded
      faraday.use      FaradayMiddleware::FollowRedirects
      set_logger_if_rails(faraday)
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

  def set_logger_if_rails(faraday) # rubocop:disable Naming/AccessorMethodName
    faraday.response :logger, Rails.logger if defined?(Rails) && Rails.env.development?
  end

  def as_http_api(api)
    api.start_with?('http:') ? api : "#{url}#{api}"
  end

  def parser
    @parser ||= Yajl::Parser.new
  end

  def report_json_failure(json)
    if defined?(Rails)
      msg = 'JSON result was not parsed correctly (no temp file saved)'
      Rails.logger.info(msg)
      throw msg
    else
      throw 'JSON result was not parsed correctly: ' + json.slice(0, 1000)
    end
  end
end
