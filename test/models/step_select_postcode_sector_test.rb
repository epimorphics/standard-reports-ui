# Unit tests on the StepSelectPostcodeArea class

require 'test_helper'

class StepSelectPostcodeSectorTest < ActiveSupport::TestCase
  let( :step ) {StepSelectPostcodeSector.new}
  let( :workflow_empty_state ) {Workflow.new( {} )}

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
    successor = step.traverse( workflow_empty_state )
    successor.name.must_equal :select_pc_sector
  end

  it 'should select dates as the next step if postcode sector is selected' do
    workflow = Workflow.new( area: "BA6 8" )
    successor = step.traverse( workflow )
    successor.name.must_equal :select_dates
  end

  it 'should select remain on this step if the validation does not pass and set the flash' do
    workflow = Workflow.new( area: "BA" )
    successor = step.traverse( workflow )
    successor.name.must_equal :select_pc_sector
    step.flash.must_match /Sorry/
  end

end
