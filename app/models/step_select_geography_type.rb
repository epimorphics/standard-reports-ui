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
      Struct::StepValue.new( "Post-code area", :pcArea ),
      Struct::StepValue.new( "Post-code district", :pcDistrict ),
      Struct::StepValue.new( "Post-code sector", :pcSector )
    ]
  end

  def traverse( workflow )
    area_type = workflow.state( param_name )
    case
    when area_type == "country"
      traverse_area_type_country( workflow )
    when area_type
      workflow.traverse_to( :"select_#{area_type.underscore}" )
    else
      self
    end
  end

  def summarise( state_value, connector = "is " )
    "geography type #{connector}#{state_value}"
  end

  private

  def traverse_area_type_country( workflow )
    workflow.set_state( :area, ENGLAND_AND_WALES )
    workflow.traverse_to( :select_aggregation_type )
  end

end
