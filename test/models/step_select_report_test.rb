# Unit tests on the StepSelectReport class

require 'test_helper'

class StepSelectReportTest < ActiveSupport::TestCase
  let( :step ) {StepSelectReport.new}

  it 'should have a name' do
    step.name.must_equal :select_report
  end

  it 'should have a parameter' do
    step.param_name.must_equal :rt
  end

  it 'should have a layout' do
    step.layout.must_equal :radio
  end

  it 'should have at least two values' do
    step.values.length.must_be :>=, 2
  end
end
