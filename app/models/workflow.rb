# Model encapsulating the report-generation workflow

class Workflow
  attr_reader :params, :initial_step

  STEP_CLASSES = [
    StepSelectReport,
    StepSelectAreaType,
    StepSelectAggregationType,
    StepSelectDates,
    StepSelectOptions,
    StepReviewReport,
    StepSelectRegion,
    StepSelectCounty,
    StepSelectDistrict,
    StepSelectPostcodeArea,
    StepSelectPostcodeDistrict,
    StepSelectPostcodeSector
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
    @state.each do |key, value|
      unless key == ignore
        block.yield( key, value )
      end
    end
  end

  def summarise_selection( state_name, state_value )
    if (step = step_with_param( state_name ))
      step.summarise( state_value )
    end
  end

  def step_with_param( state_name )
    steps.values.find {|step| step.param_name == state_name}
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
