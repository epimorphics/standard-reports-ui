# Workflow step of selecting a report

class StepSelectReport < Step
  def initialize
    super( :select_report, :rt, :radio )
  end

  def values
    [
      Struct::StepValue.new( "Average prices and volumes", :byPrice ),
      Struct::StepValue.new( "Banded prices", :banded ),
    ]
  end
end
