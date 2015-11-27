# Service object for interacting with remote service-manager API

class ReportManager
  DEFAULT_URL = "http://localhost:8080/sr-manager/"

  def initialize( config = nil )
    if config
      @url = config[:url]
      @api = config[:api]
      start_requests( config[:params] ) if config[:params]
    end
  end

  def latest_month
    latest_month_spec.split( "-" ).second.to_i
  end

  def latest_year
    latest_month_spec.split( "-" ).first.to_i
  end

  def latest_month_spec
    @latest_month_spec ||= api.get( url + "latest-month-available", {accept: "text/plain"} )
  end

  private

  def url
    @url ||= DEFAULT_URL
  end

  def api
    @api ||= ReportManagerApi.new
  end

  def start_requests( params )
    psets = create_params_sets( params )
    @requests = psets.map do |pset|
      start_request( pset )
    end
  end

  # Convert a hash with optionally multiple values for some
  # keys into an array of hashes where every key has only a
  # single value
  def create_params_sets( params )
    separated = [Hash.new]

    params.each do |k,v|
      separated_ = []
      separated.each do |h|
        (v.is_a?( Array ) ? v : [v]).each do |vv|
          h_copy = h.dup
          h_copy[k] = vv
          separated_ << h_copy
        end
      end
      separated = separated_
    end

    separated
  end

  def start_request( pset )
    @requests = pset.map do |request_params|
      post_json( "#{url}/report-request", request_params )
    end
  end

end
