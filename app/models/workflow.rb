# Model encapsulating the report-generation workflow

class Workflow

  STEPS = [
    StepSelectReport.new
  ]

  def initialize( params )
  end

  def current_step
    initial_step
  end

  def initial_step
    steps.first
  end

  def steps
    STEPS
  end
end
