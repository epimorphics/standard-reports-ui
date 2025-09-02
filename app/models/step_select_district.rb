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

  def names # rubocop:disable Metrics/MethodLength
    read_data_file('data/district-names.txt')
  rescue Errno::ENOENT => e
    Rails.logger.error "District names file not found: #{e.message}"
    []
  rescue JSON::ParserError => e
    Rails.logger.error "Error parsing district names file: #{e.message}"
    []
  rescue StandardError => e
    Rails.logger.error "Error loading district names: #{e.message}"
    []
  ensure
    Rails.logger.info 'Finished processing district names' if Rails.logger.debug?
  end

  def input_label
    'District or local authority name'
  end

  def successor_step
    :select_aggregation_type
  end
end
