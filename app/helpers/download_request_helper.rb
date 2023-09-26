# frozen_string_literal: true

# :nodoc:
module DownloadRequestHelper
  def render_report_request(request)
    content_tag(:li) do
      content_tag(:div, class: 'o-request', data: { running: request.running? }) do
        concat(report_id(request))
        concat(tag(:br))
        concat(request_status(request))
      end
    end
  end

  def request_status(request) # rubocop:disable Metrics/MethodLength
    capture do
      if request.unknown?
        concat render_unknown_request(request)
      elsif request.failed?
        concat render_failed_request(request)
      elsif request.completed?
        concat render_completed_request(request)
      elsif request.in_progress?
        concat render_in_progress_request(request)
      else
        concat render_pending_request(request)
      end
    end
  end

  def render_unknown_request(request)
    content_tag(:span, class: 'o-request--status__warning') do
      "Request #{request.id} was not recognised as a valid report request."
    end
  end

  def render_failed_request(request)
    content_tag(:span, class: 'o-request--status__warning') do
      "Request #{request.id} did not complete successfully." \
        'Ideally we will put more info here. In the meantime, please check the log file'
    end
  end

  def render_completed_request(request) # rubocop:disable Metrics/MethodLength
    content_tag(:span, class: 'o-request--status__success') do
      concat('Ready: ')
      concat(tag(:br))
      concat(
        link_to("Microsoft Excel format <i class='fa fa-external-link'></i>".html_safe,
                request.url(:xlsx))
      )
      concat(tag(:br))
      concat(
        link_to("open-data (csv) format <i class='fa fa-external-link'></i>".html_safe,
                request.url(:csv))
      )
    end
  end

  def render_in_progress_request(request)
    eta = request.eta || 0
    remaining = distance_of_time_in_words(eta / 1000, 0, include_seconds: true)
    content_tag(:span, "in progress, estimated complete in #{remaining}.",
                class: 'o-request--status__in-progress')
  end

  def render_pending_request(request)
    content_tag(:span, "waiting to start. Position in queue: #{request.position}",
                class: 'text-muted o-request--status__pending')
  end

  def report_id(request)
    content_tag(:span, request.label, class: 'o-request--status__report-id')
  end
end
