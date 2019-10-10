# frozen_string_literal: true

# Unit tests on ReportSpecification
require 'models/mock_report_manager'

class ReportSpecificationTest < ActiveSupport::TestCase
  include MockReportManager

  it 'should record parameters correctly' do
    rs = ReportSpecification.new({ a: 1, b: 2 }, nil)
    _(rs.to_hash[:a]).must_equal 1
    _(rs.to_hash[:b]).must_equal 2
    _(rs.to_hash[:c]).must_be_nil
  end

  it 'should normalise the latest year' do
    rm = mock_report_manager(9, 2015)
    rs = ReportSpecification.new({ period: 'ytd' }, rm)
    _(rs.to_hash[:period]).must_equal(2015)
  end

  it 'should normalise the latest month' do
    rm = mock_report_manager(9, 2015)
    rs = ReportSpecification.new({ period: 'latest_m' }, rm)
    _(rs.to_hash[:period]).must_equal('2015-09')
  end

  it 'should normalise the latest quarter' do
    expectations = [
      { m: 1,  q: '2014-Q4' },
      { m: 2,  q: '2014-Q4' },
      { m: 3,  q: '2015-Q1' },
      { m: 4,  q: '2015-Q1' },
      { m: 5,  q: '2015-Q1' },
      { m: 6,  q: '2015-Q2' },
      { m: 7,  q: '2015-Q2' },
      { m: 8,  q: '2015-Q2' },
      { m: 9,  q: '2015-Q3' },
      { m: 10, q: '2015-Q3' },
      { m: 11, q: '2015-Q3' },
      { m: 12, q: '2015-Q4' }
    ]

    expectations.each do |expectation|
      _(
        ReportSpecification
          .new({ period: 'latest_q' }, mock_report_manager(expectation[:m], 2015))
          .to_hash[:period]
      )
        .must_equal(expectation[:q])
    end
  end
end
