# frozen_string_literal: true

# Workflow step of selecting a postcode district
class StepSelectPostcodeDistrict < StepSelectPostcode
  VALIDATION = /\A[A-Z][A-Z]?[0-9][0-9]?[A-Z]?\Z/.freeze

  def initialize
    super(:select_pc_district)
  end

  def subtype_label
    'postcode district'
  end

  def subtype
    'pcDistrict'
  end

  def validation_pattern
    VALIDATION
  end

  def input_label
    'Enter postcode district:'
  end
end
