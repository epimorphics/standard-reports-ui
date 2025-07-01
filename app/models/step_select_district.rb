# frozen_string_literal: true

# Workflow step of selecting a county
class StepSelectDistrict < StepSelectCountyOrDistrict
  include ApplicationHelper

  def initialize
    super(:select_district, :area)
  end

  def subtype
    'district'
  end
  alias subtype_label subtype

  def names
    read_data_file('data/district-names.txt')
  end

  def input_label
    'District or local authority name'
  end

  def successor_step
    :select_aggregation_type
  end


end
