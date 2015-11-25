# Unit tests on Step class

require 'test_helper'

class StepTest < ActiveSupport::TestCase
  let( :step ) {Step.new( :test_step, :test_param, :test_layout )}

  it 'should have a name' do
    step.name.must_equal :test_step
  end

  it 'should have a parameter' do
    step.param_name.must_equal :test_param
  end

  it 'should have a layout' do
    step.layout.must_equal :test_layout
  end

  it 'should not report as completed if the param is missing' do
    step.completed?( {} ).must_equal false
  end

  it 'should report as completed if the param is present' do
    step.completed?( {test_param: "abc"} ).must_equal true
  end
end
