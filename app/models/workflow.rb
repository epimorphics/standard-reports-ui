# Model encapsulating the report-generation workflow

class Workflow
  extend Forwardable

  attr_reader :params, :step_history

  STEP_CLASSES = [
    StepSelectReport,
    StepSelectAreaType,
    StepSelectCountry,
    StepSelectRegion,
    StepSelectCounty,
    StepSelectDistrict,
    StepSelectPostcodeArea,
    StepSelectPostcodeDistrict,
    StepSelectPostcodeSector,
    StepSelectAggregationType,
    StepSelectDates,
    StepSelectOptions,
    StepReviewReport
  ]

  STEP_SEQUENCE = STEP_CLASSES
    .map( &:new )
    .uniq &:param_name

  def initialize( params )
    set_current_state( params )
    build_workflow_tree
    traverse_workflow
  end

  def initial_step
    step_history.first
  end

  def prior_step
    step_history[-2]
  end

  def current_step
    step_history.last
  end

  def steps
    @steps ||= Hash.new
  end

  def step( name )
    steps[name]
  end

  def has_state?( name, value = nil )
    sv = state( name )
    if value
      is_or_includes?( sv, value )
    else
      !!sv
    end
  end

  def traverse_to( step_name )
    raise "unknown step #{step_name}" unless next_step = step( step_name )
    @step_history << next_step
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

  def params
    @params ||= @state.select {|k,v| whitelist_key( k )}
  end

  def_delegator :params, :each, :each_state_key

  def each_state_ignoring( ignore = nil, &block )
    params.each do |key, values|
      each_state_value( key, values, &block ) unless key == ignore
    end
  end

  def whitelist_key( key )
    step_with_param( key )
  end

  def summarise_selection( state_name, state_value )
    if (step = step_with_param( state_name ))
      step.summarise( state_value )
    end
  end

  def step_with_param( state_name )
    steps.values.find {|step| step.provides?( state_name, self )}
  end

  def step_progress_summary
    step_no = STEP_SEQUENCE.find_index do |s|
      s.incomplete?( self ) || has_state?( :stop, s.param_name )
    end
    "Step #{step_no + 1} of #{STEP_SEQUENCE.length}"
  end

  private

  def each_state_value( key, values, &block )
    multi = values.is_a?( Array )
    param_name = multi ? "#{key}[]" : key.to_s

    (multi ? values : [values]).each do |value|
      block.yield( key, value, param_name )
    end
  end

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
    @step_history ||= [step]
  end

  def save_step( step )
    steps[step.name] = step
  end

  def traverse_workflow
    initial_step.traverse( self )
  end

  def is_or_includes?( value, v )
    if value.is_a?( Array )
      value.include?( v.to_s )
    else
      value.to_s == v.to_s
    end
  end
end
