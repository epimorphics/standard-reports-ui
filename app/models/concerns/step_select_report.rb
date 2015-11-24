# Step to select a report type

class StepSelectReport < Step
  def initialize
    super( :select_report, :rt )
  end

  def values
    [
      Struct::StepValue.new( "Average prices and volumes", :avg_price ),
      Struct::StepValue.new( "Banded prices", :banded_price )
    ]
  end
end
