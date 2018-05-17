# frozen_string_literal: true

# Generic super-class for all area-selection steps
class StepSelectArea < Step
  def generic_name
    'select area'
  end

  def provides?(state_name, workflow)
    param_name == state_name && workflow.has_state?(:areaType, subtype)
  end
end
