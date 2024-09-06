# frozen_string_literal: true

# Workflow step of selecting a county
class StepSelectCountyOrDistrict < StepSelectArea
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
    unless normalized_value && (value(workflow) == normalized_value)
      workflow.set_state(param_name, input_text)
    end

    normalized_value || validation_failure(input_text)
  end

  def validation_failure(input_text)
    set_flash("Sorry, #{subtype_label} '#{input_text}' was not recognised")
    false
  end

  def summarise(state_value, connector = 'is ')
    "<span class='c-review-report--summary-key'>#{subtype_label.capitalize} #{connector}</span>" \
      "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end

  def validate(value)
    normalized_value = value.upcase
    names.include?(normalized_value) && normalized_value
  end

  def successor_step
    :select_aggregation_type
  end
end
