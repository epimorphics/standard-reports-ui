# frozen_string_literal: true

# Workflow step of reviewing report options
class StepReviewReport < Step
  def initialize
    super(:review_report, :confirm, nil)
  end

  def values(_workflow = nil)
    []
  end

  def traverse(_workflow)
    self
  end

  def generic_name
    'review'
  end
end
