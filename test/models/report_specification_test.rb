# Unit tests on ReportSpecification

class ReportSpecificationTest < ActiveSupport::TestCase
  it "should record parameters correctly" do
    rs = ReportSpecification.new( {a: 1, b: 2}, nil )
    rs.to_hash()[:a].must_equal 1
    rs.to_hash()[:b].must_equal 2
    rs.to_hash()[:c].must_equal nil
  end

  it "should normalise the latest year" do
    rm = mock_report_manager( 9, 2015 )
    rs = ReportSpecification.new( {period: "ytd"}, rm )
    rs.to_hash()[:period].must_equal( 2015 )
  end

  it "should normalise the latest month" do
    rm = mock_report_manager( 9, 2015 )
    rs = ReportSpecification.new( {period: "latest_m"}, rm )
    rs.to_hash()[:period].must_equal( "2015-09" )
  end

  it "should normalise the latest quarter" do
    expectations = [
      {m: 1,  q: "2014-Q4"},
      {m: 2,  q: "2014-Q4"},
      {m: 3,  q: "2015-Q1"},
      {m: 4,  q: "2015-Q1"},
      {m: 5,  q: "2015-Q1"},
      {m: 6,  q: "2015-Q2"},
      {m: 7,  q: "2015-Q2"},
      {m: 8,  q: "2015-Q2"},
      {m: 9,  q: "2015-Q3"},
      {m: 10, q: "2015-Q3"},
      {m: 11, q: "2015-Q3"},
      {m: 12, q: "2015-Q4"},
    ]

    expectations.each do |expectation|
      ReportSpecification
        .new( {period: "latest_q"}, mock_report_manager( expectation[:m], 2015 ) )
        .to_hash()[:period].must_equal( expectation[:q] )
    end

  end

  def mock_report_manager( m, y )
    rm = mock('report_manager')
    rm.stubs(:latest_month).returns(m)
    rm.stubs(:latest_year).returns(y)
    rm.stubs(:latest_month_spec).returns( "#{y}-%02d" % m )
    rm
  end
end
