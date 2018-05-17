# frozen_string_literal: true

# Workflow step of selecting a postcode sector
class StepSelectPostcodeSector < StepSelectPostcode
  def initialize
    super(:select_pc_sector)
  end

  def subtype_label
    'postcode sector'
  end

  def subtype
    'pcSector'
  end

  def validation_pattern
    /\A[A-Z][A-Z]?[0-9][0-9]?[A-Z]? [0-9]\Z/
  end

  def input_label
    'Enter postcode sector:'
  end

  def successor_step
    :select_aggregation_type
  end
end
