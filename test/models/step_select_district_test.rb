# frozen_string_literal: true

require 'test_helper'

# Unit tests on the StepSelectDistrict class
class StepSelectDistricTest < ActiveSupport::TestCase
  let(:step) { StepSelectDistrict.new }
  let(:workflow_empty_state) { Workflow.new({}) }

  it 'should have a name' do
    step.name.must_equal :select_district
  end

  it 'should have a parameter' do
    step.param_name.must_equal :area
  end

  it 'should have a layout' do
    step.layout.must_equal :textinput
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse(workflow_empty_state)
    successor.name.must_equal :select_district
  end

  it 'should select aggregation as the next step if district is selected' do
    workflow = Workflow.new(area: 'MENDIP')
    successor = step.traverse(workflow)
    successor.name.must_equal :select_aggregation_type
  end

  it 'should select remain on this step if the validation does not pass and set the flash' do
    workflow = Workflow.new(area: 'XXMENDIP')
    successor = step.traverse(workflow)
    successor.name.must_equal :select_district
    step.flash.must_match(/Sorry/)
  end

  it 'should have a generic name' do
    step.generic_name.must_equal 'select area'
  end

  it 'should answer that the step provides the param name if the area type is district' do
    w = Workflow.new(areaType: 'district')
    step.provides?(:area, w).must_equal true

    w = Workflow.new(areaType: 'county')
    step.provides?(:area, w).must_equal false
  end

  it 'should no longer set the aggegation to none' do
    workflow = Workflow.new(area: 'MENDIP')
    refute workflow.has_state?(:aggregate)
    step.traverse(workflow)
    refute workflow.has_state?(:aggregate, :none)
  end

  it 'should remember the normalized value for a district' do
    workflow = Workflow.new(area: 'mendip')
    workflow.state('area').must_equal 'mendip'
    successor = step.traverse(workflow)
    successor.name.must_equal :select_aggregation_type
    workflow.state('area').must_equal 'MENDIP'
  end
end
