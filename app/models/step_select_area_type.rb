# frozen_string_literal: true

# Workflow step of selecting a geograpy type
class StepSelectAreaType < Step
  def initialize
    super(:select_area_type, :areaType, :radio)
  end

  def values_options(_workflow)
    [
      ['Country', :country],
      ['Region', :region],
      ['County, Unitary Authority or Greater London', :county],
      ['District or London Borough', :district],
      ['Postcode area (e.g. &lsquo;GL&rsquo;)'.html_safe, :pcArea],
      ['Postcode district (e.g. &lsquo;GL1&rsquo;)'.html_safe, :pcDistrict],
      ['Postcode sector (e.g. &lsquo;GL1 2&rsquo;)'.html_safe, :pcSector]
    ]
  end

  def traverse(workflow)
    if (area_type = workflow.state(param_name)) && !stop?(workflow)
      workflow_update_hook(workflow)
      workflow.traverse_to(:"select_#{area_type.underscore}")
    else
      self
    end
  end

  def summarise(state_value, connector = 'is ')
    "<span class='c-review-report--summary-key'>area type #{connector}</span>" \
      "<span class='c-review-report--summary-value'>#{state_value}</span>"
  end

  def generic_name
    'select area type'
  end
end
