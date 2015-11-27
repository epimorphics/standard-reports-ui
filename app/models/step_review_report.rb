# Workflow step of reviewing report options

class StepReviewReport < Step
  def initialize
    super( :review_report, :confirm, nil )
  end

  def values( workflow = nil )
    []
  end

  def traverse( workflow )
    self
  end
end
