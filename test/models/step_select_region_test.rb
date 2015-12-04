# Unit tests on the StepSelectRegion class

require 'test_helper'

class StepRegionTest < ActiveSupport::TestCase
  let( :step ) {StepSelectRegion.new}
  let( :workflow_empty_state ) {Workflow.new( {} )}

  it 'should have a name' do
    step.name.must_equal :select_region
  end

  it 'should have a parameter' do
    step.param_name.must_equal :area
  end

  it 'should have a layout' do
    step.layout.must_equal :radio
  end

  it 'should have at least eight values' do
    step.values.length.must_be :>=, 8
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse( workflow_empty_state )
    successor.name.must_equal :select_region
  end

  it 'should select aggregation-type as the next step if region is selected' do
    workflow = Workflow.new( area: "region" )
    successor = step.traverse( workflow )
    successor.name.must_equal :select_aggregation_type
  end

end