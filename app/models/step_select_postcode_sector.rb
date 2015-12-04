# Workflow step of selecting a postcode sector

class StepSelectPostcodeSector < StepSelectPostcode

  def initialize
    super( :select_pc_sector )
  end

  def subtype
    "postcode sector"
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
