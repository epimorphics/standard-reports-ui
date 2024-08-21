# frozen_string_literal: true

# Super-class for common elements of picking a postcode
class StepSelectPostcode < StepSelectArea
  def initialize(param)
    super(param, :area, :textinput)
  end

  def traverse(workflow)
    value = workflow.state(param_name)
    if value && !stop?(workflow)
      validate_with(workflow, value)
    else
      self
    end
  end

  def validate(value)
    normalized_value = value.upcase
    normalized_value =~ validation_pattern && normalized_value
  end

  def summarise(state_value, connector = 'is ')
    "<span class='c-review-report--summary-key'>#{subtype_label} #{connector}</span>" \
      "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end

  def successor_step
    :select_aggregation_type
  end
end
