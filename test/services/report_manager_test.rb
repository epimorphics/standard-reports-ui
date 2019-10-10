# frozen_string_literal: true

# Service tests on ReportManager
require 'test_helper'

class ReportManagerTest < ActiveSupport::TestCase
  it 'should report the latest month on request' do
    api = mock('report_manager_api')
    api.stubs(:get).returns('2015-09')

    rm = ReportManager.new(api: api)

    _(rm.latest_month).must_equal 9
    _(rm.latest_year).must_equal 2015
    _(rm.latest_month_spec).must_equal '2015-09'
  end

  it 'should permit valid requests' do
    api = mock('report_manager_api')
    api.stubs(:get).returns('2015-09')
    api.stubs(:post_json).returns(test_double: true)

    params = ActionController::Parameters.new(
      report: 'avgPrice',
      areaType: 'region',
      area: 'EAST MIDLANDS',
      aggregate:  'county',
      period: %w[ytd 2018],
      age:  'any'
    )

    rm = ReportManager.new(api: api, params: params)
    _(rm.valid?).must_equal true
    _(rm.errors).must_be_nil
  end

  it 'should reject invalid requests (no period)' do
    api = mock('report_manager_api')
    api.stubs(:get).returns('2015-09')

    params = ActionController::Parameters.new(
      report: 'avgPrice',
      areaType: 'region',
      area: 'EAST MIDLANDS',
      aggregate:  'county',
      age:  'any'
    )

    rm = ReportManager.new(api: api, params: params)
    _(rm.valid?).must_equal false
    _(rm.errors).must_equal 'missing parameter period'
  end

  it 'should reject invalid requests (no value for period)' do
    api = mock('report_manager_api')
    api.stubs(:get).returns('2015-09')

    params = ActionController::Parameters.new(
      report: 'avgPrice',
      areaType: 'region',
      area: 'EAST MIDLANDS',
      aggregate:  'county',
      period: [],
      age:  'any'
    )

    rm = ReportManager.new(api: api, params: params)
    _(rm.valid?).must_equal false
    _(rm.errors).must_equal 'missing parameter period'
  end

  it 'should reject invalid requests (no area)' do
    api = mock('report_manager_api')
    api.stubs(:get).returns('2015-09')

    params = ActionController::Parameters.new(
      report: 'avgPrice',
      areaType: 'region',
      aggregate: 'county',
      period: [2018],
      age: 'any'
    )

    rm = ReportManager.new(api: api, params: params)
    _(rm.valid?).must_equal false
    _(rm.errors).must_equal 'missing parameter area'
  end
end
