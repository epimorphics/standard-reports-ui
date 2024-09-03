# frozen_string_literal: true

# :nodoc:
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :change_default_caching_policy
  around_action :log_request_result

  # * Set cache control headers for HMLR apps to be public and cacheable
  # * Standard Reports uses a time limit of 5 minutes (300 seconds)
  # Sets the default `Cache-Control` header for all requests,
  # unless overridden in the action
  def change_default_caching_policy
    expires_in 5.minutes, public: true, must_revalidate: true if Rails.env.production?
  end

  def log_request_result
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    yield
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond) - start
    detailed_request_log(duration)
  end

  # Handle specific types of exceptions and render the appropriate error page
  # or attempt to render a generic error page if no specific error page exists
  unless Rails.application.config.consider_all_requests_local
    rescue_from StandardError do |e|
      case e.class
      when ActionController::RoutingError, ActionView::MissingTemplate
        :render404
      when ActionController::InvalidCrossOriginRequest
        :render403
      when ActionController::ParameterMissing
        :render400
      else
        :handle_internal_error
      end
    end
  end

  def handle_internal_error(exception)
    # Notify subscribers of the internal error event and render the appropriate error page
    # or attempt to render a generic error page if no specific error page exists
    # unless the exception is a 404, in which case do nothing
    instrument_internal_error(exception) unless exception.status == 404
    if exception.instance_of? ArgumentError
      render_error(400)
    else
      Rails.logger.warn "No explicit error page for exception #{exception} - #{exception.class}"
      render_error(500)
    end
  end

  def render_400(_exception = nil) # rubocop:disable Naming/VariableNumber
    render_error(400)
  end

  def render_403(_exception = nil) # rubocop:disable Naming/VariableNumber
    render_error(403)
  end

  def render_404(_exception = nil) # rubocop:disable Naming/VariableNumber
    render_error(404)
  end

  def render_500(_exception = nil) # rubocop:disable Naming/VariableNumber
    render_error(500)
  end

  def render_error(status)
    reset_response

    respond_to do |format|
      format.html { render_html_error_page(status) }
      # Anything else returns the status as human readable plain string
      format.all { render plain: Rack::Utils::HTTP_STATUS_CODES[status].to_s, status: status }
    end
  end

  def render_html_error_page(status)
    render(layout: true,
           file: Rails.root.join('public', 'landing', status.to_s),
           status: status)
  end

  def reset_response
    self.response_body = nil
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def detailed_request_log(duration)
    env = request.env

    log_fields = {
      duration: duration,
      request_id: env['X_REQUEST_ID'],
      forwarded_for: env['X_FORWARDED_FOR'],
      path: env['REQUEST_PATH'],
      query_string: env['QUERY_STRING'],
      user_agent: env['HTTP_USER_AGENT'],
      accept: env['HTTP_ACCEPT'],
      body: request.body.gets&.gsub("\n", '\n'),
      method: request.method,
      status: response.status,
      message: Rack::Utils::HTTP_STATUS_CODES[response.status]
    }

    case response.status
    when 500..599
      log_fields[:message] = env['action_dispatch.exception']
      Rails.logger.error(JSON.generate(log_fields))
    when 400..499
      Rails.logger.warn(JSON.generate(log_fields))
    else
      Rails.logger.info(JSON.generate(log_fields))
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # Notify subscriber(s) of an internal error event with the payload of the
  # exception once done
  # @param [Exception] exp the exception that caused the error
  # @return [ActiveSupport::Notifications::Event] provides an object-oriented
  # interface to the event
  def instrument_internal_error(exception)
    ActiveSupport::Notifications.instrument('internal_error.application', exception: exception)
  end
end
