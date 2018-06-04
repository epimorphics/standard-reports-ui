# frozen_string_literal: true

require 'test_helper'

# Unit tests on the StepSelectPostcodeSector class
class StepSelectPostcodeSectorTest < ActiveSupport::TestCase
  let(:step) { StepSelectPostcodeSector.new }
  let(:workflow_empty_state) { Workflow.new({}) }

  it 'should have a name' do
    step.name.must_equal :select_pc_sector
  end

  it 'should have a parameter' do
    step.param_name.must_equal :area
  end

  it 'should have a layout' do
    step.layout.must_equal :textinput
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse(workflow_empty_state)
    successor.name.must_equal :select_pc_sector
  end

  it 'should select aggregation type as the next step if postcode sector is selected' do
    workflow = Workflow.new(area: 'BA6 8')
    successor = step.traverse(workflow)
    successor.name.must_equal :select_aggregation_type
  end

  it 'should select remain on this step if the validation does not pass and set the flash' do
    workflow = Workflow.new(area: 'BA')
    successor = step.traverse(workflow)
    successor.name.must_equal :select_pc_sector
    step.flash.must_match(/Sorry/)
  end

  it 'should have a generic name' do
    step.generic_name.must_equal 'select area'
  end

  it 'should answer that the step provides the param name if the area type is pcSector' do
    w = Workflow.new(areaType: 'pcSector')
    step.provides?(:area, w).must_equal true

    w = Workflow.new(areaType: 'district')
    step.provides?(:area, w).must_equal false
  end

  it 'should no longer set the aggegation to none' do
    workflow = Workflow.new(area: 'BA6 8')
    refute workflow.has_state?(:aggregate)
    step.traverse(workflow)
    refute workflow.has_state?(:aggregate, :none)
  end
end
