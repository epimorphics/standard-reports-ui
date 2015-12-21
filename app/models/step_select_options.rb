# Workflow step of selecting report options

class StepSelectOptions < Step

  def initialize
    super( :select_options, :age, :radio )
  end

  def values_options( workflow = nil )
    [
      ["New-build properties only", :new],
      ["Existing properties only", :old],
      ["Both old and new properties", :any]
    ]
  end

  def traverse( workflow )
    simple_traverse( workflow, :review_report )
  end

  def summarise( state_value, connector = "is " )
    "<span class='c-review-report--summary-key'>age of property #{connector}</span>" +
    "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end

  def generic_name
    "options"
  end
end
