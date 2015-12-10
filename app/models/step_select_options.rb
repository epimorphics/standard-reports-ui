# Workflow step of selecting report options

class StepSelectOptions < Step

  def initialize
    super( :select_options, :age, :radio )
  end

  def values( workflow = nil )
    [
      Struct::StepValue.new( "New-build properties only", :new ),
      Struct::StepValue.new( "Existing properties only", :old ),
      Struct::StepValue.new( "Both old and new properties", :any )
    ]
  end

  def traverse( workflow )
    simple_traverse( workflow, :review_report )
  end

  def summarise( state_value, connector = "is " )
    "age of property #{connector}#{state_value}"
  end

  def generic_name
    "options"
  end
end
