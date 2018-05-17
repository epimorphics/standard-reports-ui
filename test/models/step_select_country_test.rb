# frozen_string_literal: true

require 'test_helper'

# Unit tests on the StepSelectCountry class
class StepSelectCountryTest < ActiveSupport::TestCase
  let(:step) { StepSelectCountry.new }
  let(:workflow_empty_state) { Workflow.new({}) }

  it 'should have a name' do
    step.name.must_equal :select_country
  end

  it 'should have a parameter' do
    step.param_name.must_equal :area
  end

  it 'should have a layout' do
    step.layout.must_equal :radio
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse(workflow_empty_state)
    successor.name.must_equal :select_country
  end

  it 'should select aggregation-type as the next step if region is selected' do
    workflow = Workflow.new(area: 'EW')
    successor = step.traverse(workflow)
    successor.name.must_equal :select_aggregation_type
  end

  it 'should select remain on this step if the validation does not pass and set the flash' do
    workflow = Workflow.new(area: 'XXEW')
    successor = step.traverse(workflow)
    successor.name.must_equal :select_country
    step.flash.must_match(/Sorry/)
  end

  it 'should have a generic name' do
    step.generic_name.must_equal 'select area'
  end
end
