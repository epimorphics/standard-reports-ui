# Workflow step of selecting a geograpy type

class StepSelectAreaType < Step

  def initialize
    super( :select_area_type, :areaType, :radio )
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
    if area_type = workflow.state( param_name )
      workflow.traverse_to( :"select_#{area_type.underscore}" )
    else
      self
    end
  end

  def summarise( state_value, connector = "is " )
    "area type #{connector}#{state_value}"
  end

  def generic_name
    "select area type"
  end
end
