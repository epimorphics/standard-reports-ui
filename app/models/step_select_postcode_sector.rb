# frozen_string_literal: true

# Workflow step of selecting a postcode sector
class StepSelectPostcodeSector < StepSelectPostcode
  VALIDATION = /\A[A-Z][A-Z]?[0-9][0-9]?[A-Z]? [0-9]\Z/.freeze

  def initialize
    super(:select_pc_sector)
  end

  def subtype_label
    'postcode sector'
  end

  def subtype
    'pcSector'
  end

  def validation_pattern
    VALIDATION
  end

  def input_label
    'Enter postcode sector:'
  end

  def successor_step
    :select_aggregation_type
  end

  def validate_with(workflow, value)
    validated_value = validate(value)

    if validated_value
      workflow.set_state(param_name, validated_value)
      workflow_update_hook(workflow)
      workflow.traverse_to(successor_step)
    else
      set_flash("Sorry, '#{value}' does not appear to be a valid value for a #{subtype_label}.
      A #{subtype_label} is the first part of a UK postcode, up to and including the first
      digit after the space. For example 'B17 0' or 'TA9 3'.")
    end
  end
end
