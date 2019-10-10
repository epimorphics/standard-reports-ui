# frozen_string_literal: true

# Unit tests on the StepSelectReport class

require 'test_helper'

class StepSelectReportTest < ActiveSupport::TestCase
  let(:step) { StepSelectReport.new }

  it 'should have a name' do
    _(step.name).must_equal :select_report
  end

  it 'should have a parameter' do
    _(step.param_name).must_equal :report
  end

  it 'should have a layout' do
    _(step.layout).must_equal :radio
  end

  it 'should have at least two values' do
    _(step.values.length).must_be :>=, 2
  end

  it 'should have a generic name' do
    _(step.generic_name).must_equal 'select report type'
  end
end
