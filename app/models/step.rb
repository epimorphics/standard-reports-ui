# frozen_string_literal: true

Struct.new('StepValue', :label, :value, :active?)

# Base class for a workflow step
class Step
  attr_reader :name, :param_name, :layout, :flash

  def initialize(name, param_name, layout)
    @name = name
    @param_name = param_name
    @layout = layout
  end

  def completed?(workflow)
    workflow.has_state?(param_name)
  end

  def incomplete?(workflow)
    !completed?(workflow)
  end

  # Simple traversal requires only that the parameter for this
  # step has some value
  def simple_traverse(workflow, following_state)
    if workflow.has_state?(param_name) && !stop?(workflow) && validate_value(workflow)
      workflow_update_hook(workflow)
      workflow.traverse_to(following_state)
    else
      self
    end
  end

  def set_flash(message) # rubocop:disable Naming/AccessorMethodName
    @flash = message
    self
  end

  def value(workflow)
    workflow.state(param_name)
  end

  def summarise_current_value(workflow, connector = '')
    if (v = value(workflow))
      summarise(v, connector)
    else
      'unassigned'
    end
  end

  def multivalued?
    false
  end

  def form_param
    "#{param_name}#{'[]' if multivalued?}"
  end

  def provides?(state_name, _workflow)
    param_name == state_name
  end

  def stop?(workflow)
    workflow.has_state?(:stop, param_name.to_s)
  end

  def create_values(workflow = nil)
    values_options(workflow).map do |options|
      create_value(*options, workflow)
    end
  end
  alias values create_values

  def create_value(label, value, workflow)
    Struct::StepValue.new(label, value, workflow&.has_state?(param_name, value))
  end

  def map_enabled?
    false
  end

  # When traversing, we do nothing by default
  def workflow_update_hook(workflow); end

  def validate_value(_workflow)
    true
  end
end
