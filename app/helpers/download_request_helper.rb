module DownloadRequestHelper
  def render_report_request( request, format )
    content_tag( :li, class: "report-status" ) do
      case
      when request.unknown?
        concat render_unknown_request( request )
      when request.failed?
        concat render_failed_request( request )
      when request.completed?
        concat render_completed_request( request, format )
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

  def render_completed_request( request, format )
    content_tag( :span, class: "success" ) do
      concat( "Report ready:" )
      concat( link_to( request.label, request.url( format ) ) )
    end
  end

  def render_in_progress_request( request )
    remaining = distance_of_time_in_words( request.eta / 1000, 0, include_seconds: true )
    content_tag( :span, class: "in-progress" ) do
      concat( content_tag( :span, class: "report-label" ) do
        request.label
      concat( tag( :br ))
      concat "In progress, estimated complete in #{remaining}."
      end )
    end
  end

  def render_pending_request( request )
    content_tag( :span, class: "pending" ) do
      concat( content_tag( :span, class: "report-label" ) do
        request.label
      concat( tag( :br ))
      concat( "Waiting to start. Position in queue: #{request.position}")
      end )
    end
  end
end
