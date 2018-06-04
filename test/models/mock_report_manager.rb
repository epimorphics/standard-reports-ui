# frozen_string_literal: true

module MockReportManager
  def mock_report_manager(m, y)
    rm = mock('report_manager')
    rm.stubs(:latest_month).returns(m)
    rm.stubs(:latest_year).returns(y)
    rm.stubs(:latest_month_spec).returns(format("#{y}-%02d", m))
    rm
  end
end
