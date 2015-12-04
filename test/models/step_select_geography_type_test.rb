# Unit tests on the StepSelectAreaType class

require 'test_helper'

class StepSelectAreaTypeTest < ActiveSupport::TestCase
  let( :step ) {StepSelectAreaType.new}
  let( :workflow_empty_state ) {Workflow.new( {} )}

  it 'should have a name' do
    step.name.must_equal :select_area_type
  end

  it 'should have a parameter' do
    step.param_name.must_equal :areaType
  end

  it 'should have a layout' do
    step.layout.must_equal :radio
  end

  it 'should have at least two values' do
    step.values.length.must_be :>=, 2
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse( workflow_empty_state )
    successor.name.must_equal :select_area_type
  end

  it 'should select aggregation-type as the next step if country is selected' do
    workflow = Workflow.new( areaType: "country" )
    successor = step.traverse( workflow )
    successor.name.must_equal :select_aggregation_type
  end

  it 'should select select the default area of EW if area type country is selected' do
    workflow = Workflow.new( areaType: "country" )
    successor = step.traverse( workflow )
    workflow.has_state?( :area, "EW" ).must_equal true
  end
end
