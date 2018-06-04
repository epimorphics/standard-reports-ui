# frozen_string_literal: true

# Unit tests on Step class

require 'test_helper'

class StepTest < ActiveSupport::TestCase
  let(:step) { Step.new(:test_step, :test_param, :test_layout) }

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
    w = Workflow.new({})
    refute step.completed?(w)
    assert step.incomplete?(w)
  end

  it 'should report as completed if the param is present' do
    w = Workflow.new(test_param: 'foo')
    assert step.completed?(w)
    refute step.incomplete?(w)
  end

  it 'should answer generically that a step provides its param name' do
    assert step.provides?(:test_param, nil)
    refute step.provides?(:test_paramXX, nil)
  end
end
