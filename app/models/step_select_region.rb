# frozen_string_literal: true

# Workflow step of selecting a region
class StepSelectRegion < StepSelectArea
  def initialize
    super(:select_region, :area, :radio)
  end

  def values_options(_workflow)
    NAMES
  end

  def traverse(workflow)
    simple_traverse(workflow, :select_aggregation_type)
  end

  def summarise(state_value, connector = 'is ')
    "<span class='c-review-report--summary-key'>region #{connector}</span>" \
      "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end

  def subtype
    'region'
  end
  alias subtype_label subtype

  def map_enabled?
    true
  end

  def validate_value(workflow)
    val = value(workflow)
    NAMES.find { |n| n[1] == val } || validation_failure(val)
  end

  NAMES = [
    ['East Anglia',     'EAST ANGLIA'],
    ['East Midlands',   'EAST MIDLANDS'],
    ['Greater London',  'GREATER LONDON'],
    %w[North NORTH],
    ['North West',      'NORTH WEST'],
    ['South East',      'SOUTH EAST'],
    ['South West',      'SOUTH WEST'],
    %w[Wales WALES],
    ['West Midlands', 'WEST MIDLANDS'],
    ['Yorkshire And Humber', 'YORKS AND HUMBER']
  ].freeze

  private

  def validation_failure(val)
    set_flash("Sorry, #{val} is not a recognised region")
    false
  end
end
