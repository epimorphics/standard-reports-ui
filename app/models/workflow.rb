# Model encapsulating the report-generation workflow

class Workflow
  attr_reader :params, :initial_step, :state

  STEP_CLASSES = [
    StepSelectReport,
    StepSelectGeographyType
  ]

  def initialize( params )
    set_current_state( params )
    build_workflow_tree
  end

  def current_step
    initial_step.traverse( self )
  end

  def steps
    @steps ||= Hash.new
  end

  def step( name )
    steps[name]
  end

  def has_state?( name, value = nil )
    v = state[name]
    value ? (value == v) : !!v
  end

  def traverse_to( step_name )
    raise "unknown step #{step_name}" unless next_step = step( step_name )
    next_step.traverse( self )
  end

  private

  def set_current_state( params )
    @state = Hash.new
    params.each do |key, value|
      @state[key.to_sym] = value
    end
  end

  def build_workflow_tree
    STEP_CLASSES.each do |step_class|
      step = step_class.new
      set_initial_step( step )
      save_step( step )
    end
  end

  def set_initial_step( step )
    @initial_step ||= step
  end

  def save_step( step )
    steps[step.name] = step
  end
end
