# frozen_string_literal: true

# Service tests on ReportManager
require 'test_helper'

class ReportManagerTest < ActiveSupport::TestCase
  it 'should report the latest month on request' do
    api = mock('report_manager_api')
    api.stubs(:get).returns('2015-09')

    rm = ReportManager.new(api: api)

    rm.latest_month.must_equal 9
    rm.latest_year.must_equal 2015
    rm.latest_month_spec.must_equal '2015-09'
  end
end
