# Unit tests on Workflow model

require 'test_helper'

class WorkflowTest < ActiveSupport::TestCase
  let( :empty_workflow ) {Workflow.new( {} )}

  it 'should have at least one step defined' do
    empty_workflow.steps.wont_be_empty
  end

  it 'should choose the select report step if the workflow is just started' do
    empty_workflow.current_step.name.must_equal :select_report
  end

  let( :report_type_selected_workflow ) {Workflow.new( report: :avgPrice )}

  it 'should choose the select area step if the report has been chosen' do
    report_type_selected_workflow.current_step.name.must_equal :select_area_type
  end

  it 'should allow state values to be queried' do
    report_type_selected_workflow.has_state?( :report ).must_equal true
    report_type_selected_workflow.has_state?( :report, :avgPrice ).must_equal true
    report_type_selected_workflow.has_state?( :reportzzz ).must_equal false
    report_type_selected_workflow.has_state?( :report, :avgPricezzz ).must_equal false
  end

  it 'should allow state values to be set' do
    workflow = Workflow.new( Hash.new )
    workflow.has_state?( :foo ).must_equal false

    workflow.set_state( :foo, "bar" )
    workflow.has_state?( :foo ).must_equal true
    workflow.has_state?( :foo, "bar" ).must_equal true

    workflow.set_state(  "foozzz", "bar" )
    workflow.has_state?( :foozzz ).must_equal true
    workflow.has_state?( :foozzz, "bar" ).must_equal true
  end

  it 'should allow state values to be read' do
    report_type_selected_workflow.state( :report ).must_equal :avgPrice
  end

  it 'should not care if the state is initialized with string keys' do
    workflow = Workflow.new( "foo" => "bar", :bill => "ben" )
    workflow.has_state?( :foo ).must_equal true
    workflow.has_state?( :bill ).must_equal true
    workflow.has_state?( "foo" ).must_equal true
  end

  it 'should support iteration over state values' do
    acc = []
    report_type_selected_workflow.each_state do |s,v|
      acc << "#{s}--#{v}"
    end
    acc.must_equal ["report--avgPrice"]
  end

  it 'should support the iteration over states with multi-values' do
    acc = []
    workflow = Workflow.new( report: :avgPrice, period: ["latest_m", "latest_q"] )

    workflow.each_state do |s,v,p|
      acc << "#{p}--#{v}"
    end

    acc.must_include "report--avgPrice"
    acc.must_include "period[]--latest_m"
    acc.must_include "period[]--latest_q"
  end

  it 'should be able to summarise a state value in a readable form' do
    report_type_selected_workflow.summarise_selection( :report, "avgPrice" ).must_equal "report type is average prices and volumes"
  end

  it 'should intialise the workflow history' do
    workflow = Workflow.new( Hash.new )
    workflow.initial_step.name.must_equal :select_report
    workflow.step_history.length.must_equal 1
  end

  it 'should build the workflow history' do
    workflow = Workflow.new( report: "avgPrice" )
    workflow.current_step
    workflow.step_history.length.must_equal 2
    workflow.prior_step.name.must_equal :select_report
  end

end
