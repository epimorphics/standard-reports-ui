# frozen_string_literal: true

# Workflow step of selecting a postcode area
class StepSelectPostcodeArea < StepSelectPostcode
  def initialize
    super(:select_pc_area)
  end

  def subtype_label
    'postcode area'
  end

  def subtype
    'pcArea'
  end

  def validation_pattern
    /\A[A-Z][A-Z]?\Z/
  end

  def input_label
    'Enter postcode area:'
  end
end
