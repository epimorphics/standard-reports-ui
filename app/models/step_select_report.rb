# frozen_string_literal: true

# Workflow step of selecting a report
class StepSelectReport < Step
  def initialize
    super(:select_report, :report, :radio)
  end

  def values_options(_workflow)
    [['Average prices and volumes', :avgPrice],
     ['Banded prices', :banded]]
  end

  def traverse(workflow)
    simple_traverse(workflow, :select_area_type)
  end

  def summarise(state_value, connector = 'is ')
    case state_value.to_sym
    when :avgPrice
      "<span class='c-review-report--summary-key'>report type #{connector}</span>" \
        "<span class='c-review-report--summary-value'>average prices and volumes</span>"
    when :banded
      "<span class='c-review-report--summary-key'>report type #{connector}</span>" \
        "<span class='c-review-report--summary-value'>banded prices</span>"
    else
      'unknown report type!'
    end
  end

  def generic_name
    'select report type'
  end

  private

  def avg_price_options(workflow)
    create_value('Average prices and volumes', :avgPrice, workflow)
  end
end
