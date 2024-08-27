# frozen_string_literal: true

# Workflow step of selecting a postcode area
class StepSelectPostcodeArea < StepSelectPostcode
  VALIDATION = /\A[A-Z][A-Z]?\Z/.freeze

  def initialize
    super(:select_pc_area)
  end

  def subtype_label
    'postcode area'
  end

  def subtype
    'pcArea'
  end

  def validation_pattern
    VALIDATION
  end

  def input_label
    'Enter postcode area:'
  end

  def validate_with(workflow, value)
    validated_value = validate(value)

    if validated_value
      workflow.set_state(param_name, validated_value)
      workflow_update_hook(workflow)
      workflow.traverse_to(successor_step)
    else
      set_flash("Sorry, '#{value}' does not appear to be a valid value for a #{subtype_label}.
      A #{subtype_label} is the first one or two letters of a UK postcode, for example &quot;B&quot;
      or &quot;TA&quot".html_safe)
    end
  end
end
