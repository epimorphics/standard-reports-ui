# frozen_string_literal: true

# Workflow step of selecting a county
class StepSelectCountyOrDistrict < StepSelectArea
  include ApplicationHelper

  def initialize(step_name, param_name)
    super(step_name, param_name, :textinput)
  end

  def values(_workflow = nil)
    names.map do |county_or_district_name|
      Struct::StepValue.new(county_or_district_name.split.map(&:capitalize).join(' '),
                            county_or_district_name)
    end
  end

  def traverse(workflow)
    simple_traverse(workflow, successor_step)
  end

  def validate_value(workflow)
    input_text = value(workflow)
    normalized_value = validate(value(workflow))

    # If validation failed, return the failure message
    return validation_failure(input_text) unless normalized_value

    # Update state if needed
    workflow.set_state(param_name, normalized_value) unless value(workflow) == normalized_value

    titleise(normalized_value)
  end

  def validation_failure(input_text)
    if input_text.empty?
      set_flash("Sorry, no #{subtype_label} was selected")
    else
      # If the value is not recognised, we report it as an error
      set_flash("Sorry, '#{input_text}' is not a recognised #{subtype_label}")
    end
    # return false to indicate failure
    false
  end

  def summarise(state_value, connector = 'is ')
    "<span class='c-review-report--summary-key'>#{subtype_label.capitalize} #{connector}</span>" \
      "<span class='c-review-report--summary-value'>#{titleise(state_value)}</span>"
  end

  def validate(value)
    normalized_value = value.upcase
    names.include?(normalized_value) && normalized_value
  end

  def successor_step
    :select_aggregation_type
  end
end
