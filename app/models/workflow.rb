# Model encapsulating the report-generation workflow

class Workflow
  attr_reader :params

  STEPS = [
    StepSelectReport.new,
    StepSelectGeographyType.new
  ]

  def initialize( params )
    @params = params
  end

  def current_step
    steps.find {|step| step.incomplete?( @params )}
  end

  def initial_step
    steps.first
  end

  def steps
    STEPS
  end
end
