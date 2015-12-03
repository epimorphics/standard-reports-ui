# Workflow step of selecting a region

class StepSelectRegion < Step

  def initialize
    super( :select_region, :area, :radio )
  end

  def values( workflow = nil )
    NAMES.map do |region_name|
      Struct::StepValue.new( region_name.split.map(&:capitalize).join(' '), region_name )
    end
  end

  def traverse( workflow )
    simple_traverse( workflow, :select_aggregation_type )
  end

  def summarise( state_value )
    "Region is #{state_value}"
  end

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
