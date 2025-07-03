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

  def names # rubocop:disable Metrics/MethodLength
    read_data_file('data/county-names.txt')
  rescue Errno::ENOENT => e
    Rails.logger.error "County names file not found: #{e.message}"
    []
  rescue JSON::ParserError => e
    Rails.logger.error "Error parsing county names file: #{e.message}"
    []
  rescue StandardError => e
    Rails.logger.error "Error loading county names: #{e.message}"
    []
  ensure
    Rails.logger.info 'Finished processing county names' if Rails.logger.debug?
  end

  def input_label
    'County or unitary authority name'
  end

  def map_enabled?
    true
  end
end
