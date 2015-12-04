# Workflow step of selecting a report

class StepSelectReport < Step
  def initialize
    super( :select_report, :report, :radio )
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

  def summarise( state_value, connector = "is " )
    case state_value.to_sym
    when :avgPrice
      "report type #{connector}average prices and volumes"
    when :banded
      "report type #{connector}banded prices"
    else
      "unknown report type!"
    end
  end


end
