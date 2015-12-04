# Workflow step of selecting a postcode area

class StepSelectPostcodeArea < StepSelectPostcode

  def initialize
    super( :select_pc_area )
  end

  def subtype
    "postcode area"
  end

  def validation_pattern
    /\A[A-Z][A-Z]?\Z/
  end

  def input_label
    "Enter postcode area:"
  end

  def successor_step
    :select_aggregation_type
  end
end
