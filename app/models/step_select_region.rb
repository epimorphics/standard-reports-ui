# Workflow step of selecting a region

class StepSelectRegion < StepSelectArea

  def initialize
    super( :select_region, :area, :radio )
  end

  def values_options( workflow )
    NAMES
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

  def map_enabled?
    true
  end

  NAMES = [
    ["East Anglia",     "EAST ANGLIA"],
    ["East Midlands",   "EAST MIDLANDS"],
    ["Greater London",  "GREATER LONDON"],
    ["North",           "NORTH"],
    ["North West",      "NORTH WEST"],
    ["South East",      "SOUTH EAST"],
    ["South West",      "SOUTH WEST"],
    ["Wales",           "WALES"],
    ["West Midlands",   "WEST MIDLANDS"],
    ["Yorkshire And Humber", "YORKS AND HUMBER"]
  ]

end
