# frozen_string_literal: true

require 'test_helper'

# Unit tests on the StepSelectRegion class
class StepRegionTest < ActiveSupport::TestCase
  let(:step) { StepSelectRegion.new }
  let(:workflow_empty_state) { Workflow.new({}) }

  it 'should have a name' do
    _(step.name).must_equal :select_region
  end

  it 'should have a parameter' do
    _(step.param_name).must_equal :area
  end

  it 'should have a layout' do
    _(step.layout).must_equal :radio
  end

  it 'should have at least eight values' do
    _(step.values.length).must_be :>=, 8
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse(workflow_empty_state)
    _(successor.name).must_equal :select_region
  end

  it 'should select aggregation-type as the next step if region is selected' do
    workflow = Workflow.new(area: 'NORTH')
    successor = step.traverse(workflow)
    _(successor.name).must_equal :select_aggregation_type
  end

  it 'should select fail to validate non-regions' do
    workflow = Workflow.new(area: 'HERE BE DRAGONS')
    successor = step.traverse(workflow)
    _(successor.name).must_equal :select_region
    _(successor.flash).must_match(/Sorry/)
  end

  it 'should have a generic name' do
    _(step.generic_name).must_equal 'select area'
  end

  it 'should answer that the step provides the param name if the area type is region' do
    w = Workflow.new(areaType: 'region')
    _(step.provides?(:area, w)).must_equal true

    w = Workflow.new(areaType: 'district')
    _(step.provides?(:area, w)).must_equal false
  end
end
