# frozen_string_literal: true

# Workflow step of selecting a postcode district
class StepSelectPostcodeDistrict < StepSelectPostcode
  VALIDATION = /\A[A-Z][A-Z]?[0-9][0-9]?[A-Z]?\Z/.freeze

  def initialize
    super(:select_pc_district)
  end

  def subtype_label
    'postcode district'
  end

  def subtype
    'pcDistrict'
  end

  def validation_pattern
    VALIDATION
  end

  def input_label
    'Enter postcode district:'
  end

  def validate_with(workflow, value)
    validated_value = validate(value)

    if validated_value
      workflow.set_state(param_name, validated_value)
      workflow_update_hook(workflow)
      workflow.traverse_to(successor_step)
    else
      set_flash("Sorry, '#{value}' does not appear to be a valid value for a #{subtype_label}.
      A #{subtype_label} is the first part of a UK postcode, up to the space. For example
      'B17' or 'TA9'.")
    end
  end
end
