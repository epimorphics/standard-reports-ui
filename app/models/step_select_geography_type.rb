# Workflow step of selecting a geograpy type

class StepSelectGeographyType < Step
  ENGLAND_AND_WALES = "EW"

  def initialize
    super( :select_geography_type, :areaType, :radio )
  end

  def values( workflow = nil )
    [
      Struct::StepValue.new( "All of England and Wales", :country ),
      Struct::StepValue.new( "Region", :region ),
      Struct::StepValue.new( "County, Unitary Authority or Greater London", :county ),
      Struct::StepValue.new( "District or London Borough", :district ),
      Struct::StepValue.new( "Partial post-code", :postcode )
    ]
  end

  def traverse( workflow )
    case
    when workflow.has_state?( param_name, "country" )
      traverse_area_type_country( workflow )
    when workflow.has_state?( param_name, "region" )
      traverse_area_type_region( workflow )
    when workflow.has_state?( param_name, "county" )
      traverse_area_type_county( workflow )
    when workflow.has_state?( param_name, "district" )
      traverse_area_type_district( workflow )
    else
      self
    end
  end

  def summarise( state_value )
    "Geography type is #{state_value}"
  end

  private

  def traverse_area_type_country( workflow )
    workflow.set_state( :area, ENGLAND_AND_WALES )
    workflow.traverse_to( :select_aggregation_type )
  end

  def traverse_area_type_region( workflow )
    workflow.traverse_to( :select_region )
  end

  def traverse_area_type_county( workflow )
    workflow.traverse_to( :select_county )
  end

  def traverse_area_type_district( workflow )
    workflow.traverse_to( :select_district )
  end
end
