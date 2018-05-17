# frozen_string_literal: true

# :nodoc:
class ReportDesignController < ApplicationController
  def show
    @workflow = Workflow.new(params)
    render_named_step(@workflow)
  end

  private

  def render_named_step(workflow)
    render step_template(workflow.current_step)
  end

  def step_template(step)
    step.name.to_s
  end
end
