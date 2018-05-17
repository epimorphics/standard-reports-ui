# frozen_string_literal: true

require 'test_helper'

# Unit tests on Workflow model
class WorkflowTest < ActiveSupport::TestCase
  let(:empty_workflow) { Workflow.new({}) }

  it 'should have at least one step defined' do
    empty_workflow.steps.wont_be_empty
  end

  it 'should choose the select report step if the workflow is just started' do
    empty_workflow.current_step.name.must_equal :select_report
  end

  let(:report_type_selected_workflow) { Workflow.new(report: :avgPrice) }

  it 'should choose the select area step if the report has been chosen' do
    report_type_selected_workflow.current_step.name.must_equal :select_area_type
  end

  it 'should allow state values to be queried' do
    assert report_type_selected_workflow.has_state?(:report)
    assert report_type_selected_workflow.has_state?(:report, :avgPrice)
    refute report_type_selected_workflow.has_state?(:reportzzz)
    refute report_type_selected_workflow.has_state?(:report, :avgPricezzz)
  end

  it 'should allow state values to be set' do
    workflow = Workflow.new({})
    refute workflow.has_state?(:foo)

    workflow.set_state(:foo, 'bar')
    assert workflow.has_state?(:foo)
    assert workflow.has_state?(:foo, 'bar')

    workflow.set_state('foozzz', 'bar')
    assert workflow.has_state?(:foozzz)
    assert workflow.has_state?(:foozzz, 'bar')
  end

  it 'should allow state values to be read' do
    report_type_selected_workflow.state(:report).must_equal :avgPrice
  end

  it 'should not care if the state is initialized with string keys' do
    workflow = Workflow.new('foo' => 'bar', :bill => 'ben')
    assert workflow.has_state?(:foo)
    assert workflow.has_state?(:bill)
    assert workflow.has_state?('foo')
  end

  it 'should support iteration over state values' do
    acc = []
    report_type_selected_workflow.each_state_ignoring(nil) do |s, v|
      acc << "#{s}--#{v}"
    end
    acc.must_equal ['report--avgPrice']
  end

  it 'should support the iteration over states with multi-values' do
    acc = []
    workflow = Workflow.new(report: :avgPrice, period: %w[latest_m latest_q])

    workflow.each_state_ignoring(nil) do |_s, v, p|
      acc << "#{p}--#{v}"
    end

    acc.must_include 'report--avgPrice'
    acc.must_include 'period[]--latest_m'
    acc.must_include 'period[]--latest_q'
  end

  it 'should be able to summarise a state value in a readable form' do
    report_type_selected_workflow.summarise_selection(:report, 'avgPrice')
                                 .must_match(/report type.*average prices and volumes/)
  end

  it 'should intialise the workflow history' do
    workflow = Workflow.new({})
    workflow.initial_step.name.must_equal :select_report
    workflow.step_history.length.must_equal 1
  end

  it 'should build the workflow history' do
    workflow = Workflow.new(report: 'avgPrice')
    workflow.current_step
    workflow.step_history.length.must_equal 2
    workflow.prior_step.name.must_equal :select_report
  end

  it 'should correctly summarise county selections' do
    workflow = Workflow.new(areaType: 'county', area: 'DEVON')

    workflow.summarise_selection(:area, 'DEVON').must_match(/County.*is.*DEVON/)
  end

  it 'should traverse to the first step with an empty state' do
    workflow = Workflow.new({})
    step = StepSelectReport.new
    step_to = step.traverse(workflow)
    step_to.name.must_equal :select_report
  end

  it 'should traverse to the appropriate step with a partial state' do
    workflow = Workflow.new(report: 'avgPrices', areaType: 'county')
    step = StepSelectReport.new
    step_to = step.traverse(workflow)
    step_to.name.must_equal :select_county
  end

  it 'should stop at a step if given a stop parameter in the workflow' do
    workflow = Workflow.new(report: 'avgPrices', areaType: 'county', stop: 'areaType')
    step = StepSelectReport.new
    step_to = step.traverse(workflow)
    step_to.name.must_equal :select_area_type
  end
end
