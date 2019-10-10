# frozen_string_literal: true

# Unit tests on ReportStatus

class ReportStatusTest < ActiveSupport::TestCase
  it 'should be able to report the key' do
    status = ReportStatus.new(status_fixture_pending)
    _(status.id).must_equal 'avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015-10'
  end

  it 'should report the current status' do
    _(ReportStatus.new(status_fixture_pending).status).must_equal 'Pending'
    _(ReportStatus.new(status_fixture_in_progress).status).must_equal 'InProgress'
    _(ReportStatus.new(status_fixture_completed).status).must_equal 'Completed'
  end

  it 'should report when completed' do
    _(ReportStatus.new(status_fixture_pending).completed?).must_equal false
    _(ReportStatus.new(status_fixture_in_progress).completed?).must_equal false
    _(ReportStatus.new(status_fixture_completed).completed?).must_equal true
  end

  it 'should report when failed' do
    _(ReportStatus.new(status_fixture_in_progress).failed?).must_equal false
    _(ReportStatus.new(status: 'Failed').failed?).must_equal true
  end

  it 'should report when running' do
    _(ReportStatus.new(status_fixture_pending).running?).must_equal true
    _(ReportStatus.new(status_fixture_in_progress).running?).must_equal true
    _(ReportStatus.new(status_fixture_completed).running?).must_equal false
    _(ReportStatus.new(status: 'Failed').running?).must_equal false
  end

  it 'should report when the spec was not recognised' do
    _(ReportStatus.new(status_fixture_completed).unknown?).must_equal false
    _(ReportStatus.new(status: 'Unknown').unknown?).must_equal true
  end

  it 'should report when the report is in progress' do
    _(ReportStatus.new(status_fixture_in_progress).in_progress?).must_equal true
    _(ReportStatus.new(status_fixture_pending).in_progress?).must_equal false
  end

  it 'should report the position in the queue' do
    _(ReportStatus.new(status_fixture_pending).position).must_equal 2
  end

  it 'should report the ETA' do
    _(ReportStatus.new(status_fixture_pending).eta).must_equal 480_000
  end

  it 'should report the started time' do
    _(ReportStatus.new(status_fixture_in_progress).started_time).must_equal '09/12/15 15:26'
  end

  it 'should report the download locations' do
    _(ReportStatus.new(status_fixture_completed).url_csv).must_equal 'http://localhost:8080/sr-manager/report/avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015.csv'
    _(ReportStatus.new(status_fixture_completed).url_excel).must_equal 'http://localhost:8080/sr-manager/report/avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015.xlsx'
  end

  it 'should report a vaguely readable label' do
    _(ReportStatus.new(status_fixture_in_progress).label).must_equal 'avgPrice region EAST_ANGLIA by pcArea any 2015 Q3'
  end

  def status_fixture_in_progress
    { 'key' => 'avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015-Q3',
      'status' => 'InProgress',
      'positionInQueue' => 0,
      'eta' => 221_083,
      'started' => '09/12/15 15:26' }
  end

  def status_fixture_pending
    { 'key' => 'avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015-10',
      'status' => 'Pending',
      'positionInQueue' => 2,
      'eta' => 480_000 }
  end

  def status_fixture_completed
    { 'key' => 'avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015',
      'status' => 'Completed',
      'url' => 'http://localhost:8080/sr-manager/report/avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015.csv',
      'urlXlsx' => 'http://localhost:8080/sr-manager/report/avgPrice-region-EAST_ANGLIA-by-pcArea-any-2015.xlsx' }
  end
end
