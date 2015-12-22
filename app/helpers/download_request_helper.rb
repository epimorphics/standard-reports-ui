module DownloadRequestHelper
  def render_report_request( request )
    content_tag( :li, class: "report-status", data: {running: request.running?} ) do
      concat( report_id( request ) )
      concat( tag( :br  ))
      concat( request_status( request ) )
    end
  end

  def request_status( request )
    capture do
      case
      when request.unknown?
        concat render_unknown_request( request )
      when request.failed?
        concat render_failed_request( request )
      when request.completed?
        concat render_completed_request( request )
      when request.in_progress?
        concat render_in_progress_request( request )
      else
        concat render_pending_request( request )
      end
    end
  end

  def render_unknown_request( request )
    content_tag( :span, class: "warning" ) do
      "Request #{request.id} was not recognised as a valid report request."
    end
  end

  def render_failed_request( request )
    content_tag( :span, class: "warning" ) do
      "Request #{request.id} did not complete successfully. " + "
      Ideally we will put more info here. In the meantime, please check the log file"
    end
  end

  def render_completed_request( request )
    content_tag( :span, class: "success" ) do
      concat( "Ready: " )
      concat( tag( :br ) )
      concat( "download " )
      concat( link_to( "Microsoft Excel format", request.url( :xlsx ) ) )
      concat( tag( :br ) )
      concat( "download " )
      concat( link_to( "open-data (csv) format", request.url( :csv ) ) )
    end
  end

  def render_in_progress_request( request )
    eta = request.eta || 0
    remaining = distance_of_time_in_words( eta / 1000, 0, include_seconds: true )
    content_tag( :span, "in progress, estimated complete in #{remaining}.", class: "in-progress" )
  end

  def render_pending_request( request )
    content_tag( :span, "waiting to start. Position in queue: #{request.position}", class: "pending" )
  end

  def report_id( request )
    content_tag( :span, request.label, {class: "report-id"} )
  end
end
