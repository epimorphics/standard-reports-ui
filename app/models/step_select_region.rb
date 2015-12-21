# Workflow step of selecting a region

class StepSelectRegion < StepSelectArea

  def initialize
    super( :select_region, :area, :radio )
  end

  def values_options( workflow )
    NAMES.map do |region_name|
      [region_name.split.map(&:capitalize).join(' '), region_name]
    end
  end

  def traverse( workflow )
    simple_traverse( workflow, :select_aggregation_type )
  end

  def summarise( state_value, connector = "is " )
    "<span class='c-review-report--summary-key'>region #{connector}</span>" +
    "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end

  def subtype
    "region"
  end
  alias :subtype_label :subtype

  NAMES = [
    "EAST ANGLIA",
    "EAST MIDLANDS",
    "GREATER LONDON",
    "NORTH",
    "NORTH WEST",
    "SOUTH EAST",
    "SOUTH WEST",
    "WALES",
    "WEST MIDLANDS",
    "YORKS AND HUMBER"
  ]

end
