# Workflow step of selecting a geograpy type

class StepSelectAreaType < Step

  def initialize
    super( :select_area_type, :areaType, :radio )
  end

  def values_options( workflow )
    [
      ["All of England and Wales", :country],
      ["Region", :region],
      ["County, Unitary Authority or Greater London", :county],
      ["District or London Borough", :district],
      ["Post-code area", :pcArea],
      ["Post-code district", :pcDistrict],
      ["Post-code sector", :pcSector]
    ]
  end

  def traverse( workflow )
    if (area_type = workflow.state( param_name )) && !stop?( workflow )
      workflow.traverse_to( :"select_#{area_type.underscore}" )
    else
      self
    end
  end

  def summarise( state_value, connector = "is " )
    "<span class='summary-key'>area type #{connector}</span>" +
    "<span class='summary-value'>#{state_value}</span>"
  end

  def generic_name
    "select area type"
  end
end
