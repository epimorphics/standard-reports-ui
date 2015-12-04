# Unit tests on the StepSelectPostcodeArea class

require 'test_helper'

class StepSelectPostcodeDistrictTest < ActiveSupport::TestCase
  let( :step ) {StepSelectPostcodeDistrict.new}
  let( :workflow_empty_state ) {Workflow.new( {} )}

  it 'should have a name' do
    step.name.must_equal :select_pc_district
  end

  it 'should have a parameter' do
    step.param_name.must_equal :area
  end

  it 'should have a layout' do
    step.layout.must_equal :textinput
  end

  it 'should select itself in the traverse step if not yet complete' do
    successor = step.traverse( workflow_empty_state )
    successor.name.must_equal :select_pc_district
  end

  it 'should select aggregation type as the next step if postcode district is selected' do
    workflow = Workflow.new( area: "BA6" )
    successor = step.traverse( workflow )
    successor.name.must_equal :select_aggregation_type
  end

  it 'should select remain on this step if the validation does not pass and set the flash' do
    workflow = Workflow.new( area: "BA" )
    successor = step.traverse( workflow )
    successor.name.must_equal :select_pc_district
    step.flash.must_match /Sorry/
  end

end
