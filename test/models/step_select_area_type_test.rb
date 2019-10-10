# frozen_string_literal: true

require 'test_helper'

# Unit tests on the StepSelectAreaType class
class StepSelectAreaTypeTest < ActiveSupport::TestCase
  let(:step) { StepSelectAreaType.new }
  let(:workflow_empty_state) { Workflow.new({}) }

  it 'should have a name' do
    _(step.name).must_equal :select_area_type
  end

  it 'should have a parameter' do
    _(step.param_name).must_equal :areaType
  end

  it 'should have a layout' do
    _(step.layout).must_equal :radio
  end

  it 'should have at least two values' do
    _(step.values.length).must_be :>=, 2
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse(workflow_empty_state)
    _(successor.name).must_equal :select_area_type
  end

  it 'should select country as the next step if country is selected' do
    workflow = Workflow.new(areaType: 'country')
    successor = step.traverse(workflow)
    _(successor.name).must_equal :select_country
  end

  it 'should no longer select select the default area of EW if area type country is selected' do
    workflow = Workflow.new(areaType: 'country')
    step.traverse(workflow)
    _(workflow.has_state?(:area, 'EW')).must_equal false
  end

  it 'should have a generic name' do
    _(step.generic_name).must_equal 'select area type'
  end
end
