# frozen_string_literal: true

# Service object for interacting with remote service-manager API
class ReportManager
  DEFAULT_URL = 'http://localhost:8080/sr-manager/'

  def initialize(config = nil)
    return unless config
    @url = config[:url]
    @api = config[:api]

    return unless (params = config[:params])
    @requested_format = params[:format]
    @requested_format = @requested_format.to_sym if @requested_format
    start_requests(params)
  end

  def latest_month
    latest_month_spec.split('-').second.to_i
  end

  def latest_year
    latest_month_spec.split('-').first.to_i
  end

  def latest_quarter
    (latest_month / 3).to_i
  end

  def latest_month_spec
    @latest_month_spec ||= api.get(url + 'latest-month-available', accept: 'text/plain')
  end

  attr_reader :requested_format

  attr_reader :requests

  def as_json(_options = nil)
    requests
  end

  private

  def url
    @url ||= DEFAULT_URL
  end

  def api
    @api ||= ReportManagerApi.new
  end

  def start_requests(params)
    psets = create_params_sets(params)
    @requests = psets.map do |pset|
      req_spec = ReportSpecification.new(pset, self)
      start_request(req_spec)
    end
  end

  # Convert a hash with optionally multiple values for some
  # keys into an array of hashes where every key has only a
  # single value
  def create_params_sets(params) # rubocop:disable Metrics/MethodLength
    separated = [{}]

    params.each do |k, v|
      separated_ = []
      k_na = non_array_key(k)

      separated.each do |h|
        (v.is_a?(Array) ? v : [v]).each do |vv|
          h_copy = h.dup
          h_copy[k_na] = vv
          separated_ << h_copy
        end
      end
      separated = separated_
    end

    separated
  end

  def non_array_key(key)
    key.to_s.gsub('[]', '').to_sym
  end

  def start_request(req_spec)
    json = api.post_json("#{url}report-request", req_spec.to_hash)
    ReportStatus.new(json)
  end
end
