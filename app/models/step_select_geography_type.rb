# Workflow step of selecting a geograpy type

class StepSelectGeographyType < Step
  def initialize
    super( :select_geography_type, :gt, :radio )
  end

  def values
    [
      Struct::StepValue.new( "All of England and Wales", :country ),
      Struct::StepValue.new( "Region", :region ),
      Struct::StepValue.new( "County, Unitary Authority or Greater London", :county ),
      Struct::StepValue.new( "District or London Borough", :district ),
      Struct::StepValue.new( "Partial post-code", :postcode )
    ]
  end

  def traverse( workflow )
    self
  end
end
