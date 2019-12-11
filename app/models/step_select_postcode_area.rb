# frozen_string_literal: true

# Workflow step of selecting a postcode area
class StepSelectPostcodeArea < StepSelectPostcode
  VALIDATION = /\A[A-Z][A-Z]?\Z/.freeze

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
    VALIDATION
  end

  def input_label
    'Enter postcode area:'
  end
end
