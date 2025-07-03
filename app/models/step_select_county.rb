# frozen_string_literal: true

# Workflow step of selecting a county
class StepSelectCounty < StepSelectCountyOrDistrict
  include ApplicationHelper

  def initialize
    super(:select_county, :area)
  end

  def subtype
    'county'
  end
  alias subtype_label subtype

  def names
    read_data_file('data/county-names.txt')
  end

  def input_label
    'County or unitary authority name'
  end

  def map_enabled?
    true
  end
end
