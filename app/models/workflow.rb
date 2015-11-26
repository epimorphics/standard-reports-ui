# Model encapsulating the report-generation workflow

class Workflow
  attr_reader :params, :initial_step

  STEP_CLASSES = [
    StepSelectReport,
    StepSelectGeographyType,
    StepSelectAggregationType,
    StepSelectDates,
    StepSelectOptions
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
    v = state( name )
    value ? (value == v) : !!v
  end

  def traverse_to( step_name )
    raise "unknown step #{step_name}" unless next_step = step( step_name )
    next_step.traverse( self )
  end

  def set_state( state_name, value )
    @state[state_name.to_sym] = value
  end

  def state( state_name )
    @state[state_name.to_sym]
  end

  def form_action( controller = :report_design, action = :show )
    c = {controller: controller, action: action}
  end

  def each_state( ignore = nil, &block )
    steps.values.each do |step|
      unless (state_name = step.param_name) == ignore
        v = state( state_name )
        block.yield( state_name, v ) if v
      end
    end
  end

  private

  def set_current_state( params )
    @state = Hash.new
    params.each do |key, value|
      set_state( key, value )
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
