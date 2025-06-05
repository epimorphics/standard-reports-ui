# frozen_string_literal: true

# Subscribe to :api events
class ApiPrometheusSubscriber < ActiveSupport::Subscriber
  attach_to :api

  def response(event)
    response = event.payload[:response]
    duration = event.payload[:duration]

    Prometheus::Client.registry
                      .get(:api_status)
                      .increment(labels: { status: response.status.to_s })

    Prometheus::Client.registry
                      .get(:api_requests)
                      .increment(labels: { result: 'success' })

    Prometheus::Client.registry
                      .get(:api_response_times)
                      .observe(duration)
  end

  def connection_failure(event)
    exception = event.payload[:exception] if event.respond_to?(:exception)
    message = exception.respond_to?(:message) ? exception.message : exception.to_s

    Prometheus::Client.registry
                      .get(:api_requests)
                      .increment(labels: { result: 'failure' })

    Prometheus::Client.registry
                      .get(:api_connection_failure)
                      .increment(labels: { message: })
  end

  def service_exception(event)
    exception = event.payload[:exception]
    status = exception_status(exception)

    return if status == 404

    Prometheus::Client.registry
                      .get(:api_service_exception)
                      .increment(labels: { status: })
  end

  private

  # Extract the status from the exception
  # @param exception [Exception] The exception to extract the status from
  # @return [Integer] The status code
  def exception_status(exception)
    # Preset the status to 500
    status = 500

    begin
      # Parse the exception message as JSON
      json = JSON.parse(exception.message)
      # Update status if the JSON contains a status key
      status = json['status'] if json&.key?('status')
    rescue JSON::ParserError
      # was not JSON after all
    end
    # Update status if the exception responds to status
    status = exception.status if exception.respond_to?(:status)
    # Return the status
    status
  end
end
