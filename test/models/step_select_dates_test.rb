# frozen_string_literal: true

# Unit tests on the StepSelectDates class
require 'test_helper'
require 'models/mock_report_manager'

class StepSelectDatesTest < ActiveSupport::TestCase
  include MockReportManager

  let(:step) { StepSelectDates.new(mock_report_manager(9, 2015)) }
  let(:workflow) { Workflow.new({}) }

  it 'should have a name' do
    _(step.name).must_equal :select_dates
  end

  it 'should have a parameter' do
    _(step.param_name).must_equal :period
  end

  it 'should have a generic name' do
    _(step.generic_name).must_equal 'select dates'
  end

  it 'should have the latest values as the default values()' do
    _(step.values(workflow)[:latest]).wont_be_nil
    _(step.values(workflow)[:latest].length).must_be :>=, 3
  end

  it 'should report 12 months available for previous years' do
    months = step.months_for(2014, workflow)
    _(months.length).must_equal 12
    _(months.first.label).must_equal 'Jan 2014'
    _(months.last.label).must_equal 'Dec 2014'
  end

  it 'should report 9 months available for current year' do
    months = step.months_for(2015, workflow)
    _(months.length).must_equal 9
    _(months.first.label).must_equal 'Jan 2015'
    _(months.last.label).must_equal 'Sep 2015'
  end

  it 'should report 12 quarters available for previous years' do
    quarters = step.quarters_for(2014, workflow)
    _(quarters.length).must_equal 4
    _(quarters.first.label).must_equal 'Q1 2014'
    _(quarters.last.label).must_equal 'Q4 2014'
  end

  it 'should report 9 quarters available for current year' do
    quarters = step.quarters_for(2015, workflow)
    _(quarters.length).must_equal 3
    _(quarters.first.label).must_equal 'Q1 2015'
    _(quarters.last.label).must_equal 'Q3 2015'
  end

  it 'should provide a method for iterating over all years' do
    t = []
    step.each_year(false) do |y|
      t << y
    end
    _(t.length).must_be :>=, 21
    _(t.first).must_equal 0

    final_value = t.length - 1
    _(t.last).must_equal final_value
  end

  it 'should provide a method for iterating over hidden years' do
    t = []
    step.each_year(true) do |y|
      t << y
    end
    _(t.length).must_be :>=, 19
    _(t.first).must_equal 2

    final_value = t.length + 1
    _(t.last).must_equal final_value
  end

  it 'should report no available months if the current year is later than the latest year' do
    months = step.months_for(2016, workflow)
    _(months.length).must_equal 0
  end

  it 'should report no available quarters if the current year is later than the latest year' do
    months = step.quarters_for(2016, workflow)
    _(months.length).must_equal 0
  end
end
