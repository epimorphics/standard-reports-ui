# Workflow step of selecting a report

class StepSelectReport < Step
  def initialize
    super( :select_report, :rt, :radio )
  end

  def values( workflow = nil )
    [
      Struct::StepValue.new( "Average prices and volumes", :avgPrice ),
      Struct::StepValue.new( "Banded prices", :banded ),
    ]
  end

  def traverse( workflow )
    simple_traverse( workflow, :select_geography_type )
  end

  def summarise( state_value )
    if state_value.to_sym == :avgPrice
      "Report type is: average prices and volumes"
    else
      "Report type is: banded prices"
    end
  end


end
