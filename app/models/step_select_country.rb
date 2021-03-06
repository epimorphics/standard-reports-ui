# frozen_string_literal: true

# Workflow step of selecting a country
class StepSelectCountry < StepSelectArea
  ENGLAND_AND_WALES = 'EW'

  def initialize
    super(:select_country, :area, :radio)
  end

  def values_options(_workflow)
    [['England and Wales', ENGLAND_AND_WALES]]
  end

  def traverse(workflow)
    simple_traverse(workflow, :select_aggregation_type)
  end

  def summarise(state_value, connector = 'is ')
    case state_value
    when ENGLAND_AND_WALES
      summarise_ew(connector)
    else
      summarise_other(state_value, connector)
    end
  end

  def subtype
    'country'
  end
  alias subtype_label subtype

  def validate_value(workflow)
    (value(workflow) == ENGLAND_AND_WALES) || report_validation_failure(workflow)
  end

  private

  def report_validation_failure(workflow)
    set_flash("Sorry, #{value(workflow)} is not a valid country selection")
    false
  end

  def summarise_ew(connector)
    "<span class='c-review-report--summary-key'>country #{connector}</span>" \
      "<span class='c-review-report--summary-value'>England and Wales</span>"
  end

  def summarise_other(state_value, connector)
    "<span class='c-review-report--summary-key'>country #{connector}</span>" \
      "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end
end
