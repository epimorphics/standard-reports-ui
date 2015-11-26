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

  let( :report_type_selected_workflow ) {Workflow.new( rt: :avgPrice )}

  it 'should choose the select geography step if the report has been chosen' do
    report_type_selected_workflow.current_step.name.must_equal :select_geography_type
  end

  it 'should allow state values to be queried' do
    report_type_selected_workflow.has_state?( :rt ).must_equal true
    report_type_selected_workflow.has_state?( :rt, :avgPrice ).must_equal true
    report_type_selected_workflow.has_state?( :rtzzz ).must_equal false
    report_type_selected_workflow.has_state?( :rt, :avgPricezzz ).must_equal false
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
    report_type_selected_workflow.state( :rt ).must_equal :avgPrice
  end


  it 'should not care if the state is initialized with string keys' do
    workflow = Workflow.new( "foo" => "bar", :bill => "ben" )
    workflow.has_state?( :foo ).must_equal true
    workflow.has_state?( :bill ).must_equal true
    workflow.has_state?( "foo" ).must_equal true
  end
end
