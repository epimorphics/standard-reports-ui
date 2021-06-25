# frozen_string_literal: true

# Service object for interacting with remote service-manager API
class ReportManager # rubocop:disable Metrics/ClassLength
  def initialize(config = nil)
    return unless config

    @url = config[:url]
    @api = config[:api]

    return unless (params = config[:params])
    return unless validate?(params)

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
    @latest_month_spec ||= api.get("#{url}latest-month-available", accept: 'text/plain')
  end

  attr_reader :requested_format, :requests

  def as_json(_options = nil)
    requests
  end

  def valid?
    !errors
  end

  def errors
    @errors&.join(', ')
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
  # single value. So, for example,
  #     a=1&b[]=2&b[]=3
  # becomes
  #     [{a: 1, b: 2}, {a: 1, b: 3}]
  def create_params_sets(params) # rubocop:disable Metrics/MethodLength
    product = [{}]

    params.each do |k, v|
      product_ = []

      product.each do |h|
        (v.is_a?(Array) ? v : [v]).each do |vv|
          h_copy = h.dup
          h_copy[k] = vv
          product_ << h_copy
        end
      end
      product = product_
    end

    product
  end

  def start_request(req_spec)
    json = api.post_json("#{url}report-request", req_spec.to_hash)
    ReportStatus.new(json)
  end

  def validate?(params)
    key_present?(params, :report)
    key_present?(params, :areaType)
    key_present?(params, :area)
    key_present?(params, :aggregate)
    key_present?(params, :age)
    array_key_present?(params, :period)

    valid_postcodes?(params) if valid?

    valid?
  end

  def key_present?(params, key)
    return unless !params.key?(key) || params[key].nil? || params[key].to_s.empty?

    @errors ||= []
    @errors << "missing parameter #{key}"
  end

  def array_key_present?(params, key)
    return unless !params.key?(key) || params[key].nil? ||
                  !params[key].is_a?(Array) || params[key].empty?

    @errors ||= []
    @errors << "missing parameter #{key}"
  end

  def valid_postcodes?(params)
    area = params[:area]
    pattern = validation_pattern(params)

    return unless pattern && !pattern.match?(area)

    @errors ||= []
    @errors << 'invalid postal code'
  end

  def validation_pattern(params)
    area_type = params[:areaType].to_sym

    {
      pcSector: StepSelectPostcodeSector::VALIDATION,
      pcDistrict: StepSelectPostcodeDistrict::VALIDATION,
      pcArea: StepSelectPostcodeArea::VALIDATION
    }[area_type]
  end

  def api_service_url
    Rails.application.config.api_service_url
  end
end
