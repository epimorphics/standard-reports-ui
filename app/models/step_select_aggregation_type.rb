# Workflow step of selecting an aggregation type

class StepSelectAggregationType < Step
  AGGREGATE_BY_REGION = Struct::StepValue.new( "Region", :region )
  AGGREGATE_BY_COUNTY = Struct::StepValue.new( "County, Unitary Authority", :county )
  AGGREGATE_BY_DISTRICT = Struct::StepValue.new( "District or London Borough", :district )
  AGGREGATE_BY_PC_AREA = Struct::StepValue.new( "Postcode area", :pcArea )
  AGGREGATE_BY_PC_SECTOR = Struct::StepValue.new( "Postcode sector", :pcSector )
  AGGREGATE_BY_PC_DISTRICT = Struct::StepValue.new( "Postcode district", :pcDistrict )
  AGGREGATE_BY_NONE = Struct::StepValue.new( "Don't aggregate, just show the total", :none )

  def initialize
    super( :select_aggregation_type, :aggregate, :radio )
  end

  def values( workflow )
    avg_price_values( workflow )
  end

  def avg_price_values( workflow )
    case workflow.state( :areaType )
    when "country"
      [AGGREGATE_BY_REGION, AGGREGATE_BY_COUNTY, AGGREGATE_BY_DISTRICT,
       AGGREGATE_BY_PC_DISTRICT, AGGREGATE_BY_PC_SECTOR,
       AGGREGATE_BY_NONE]
    when "region"
      [AGGREGATE_BY_COUNTY, AGGREGATE_BY_DISTRICT,
       AGGREGATE_BY_PC_AREA, AGGREGATE_BY_PC_DISTRICT, AGGREGATE_BY_PC_SECTOR,
       AGGREGATE_BY_NONE]
    when "county"
      [AGGREGATE_BY_DISTRICT,
       AGGREGATE_BY_PC_AREA, AGGREGATE_BY_PC_DISTRICT, AGGREGATE_BY_PC_SECTOR,
       AGGREGATE_BY_NONE]
    when "pcArea"
      [AGGREGATE_BY_PC_DISTRICT, AGGREGATE_BY_PC_SECTOR,
       AGGREGATE_BY_NONE]
    when "pcDistrict"
      [AGGREGATE_BY_PC_SECTOR,
       AGGREGATE_BY_NONE]
    end
  end

  def traverse( workflow )
    simple_traverse( workflow, :select_dates )
  end

  def summarise( state_value )
    if state_value.to_sym == :none
      "do not aggregate data"
    else
      "aggregate data by #{state_value}"
    end
  end

  def generic_name
    "select aggregation"
  end
end
