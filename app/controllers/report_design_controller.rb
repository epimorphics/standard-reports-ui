# frozen_string_literal: true

# :nodoc:
class ReportDesignController < ApplicationController
  def show
    @workflow = Workflow.new(params)
    render_named_step(@workflow)
  end

  private

  def render_named_step(workflow)
    log_fields = { params: params }
    log_fields[:path] = request.path
    if workflow.current_step != workflow.initial_step
      log_fields[:path] += "?#{workflow.params.map { |k, v| "#{k}=#{v}" }.join('&amp;')}"
    end
    LoggingHelper.log_request(log_fields, 'info')
    render step_template(workflow.current_step)
  end

  def step_template(step)
    step.name.to_s
  end
end
