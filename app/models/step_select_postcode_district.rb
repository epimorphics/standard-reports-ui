# Workflow step of selecting a postcode district

class StepSelectPostcodeDistrict < StepSelectPostcode

  def initialize
    super( :select_pc_district )
  end

  def subtype
    "postcode district"
  end

  def validation_pattern
    /\A[A-Z][A-Z]?[0-9][0-9]?[A-Z]?\Z/
  end

  def input_label
    "Enter postcode district:"
  end

end
