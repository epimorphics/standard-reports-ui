# Encapsulation of the report status returned from the sr-manager API

class ReportStatus
  attr_reader :json

  def initialize( json )
    @json = HashWithIndifferentAccess.new( json )
  end

  def id
    @json[:key]
  end

  def status
    @json[:status]
  end

  def completed?
    status == "Completed"
  end

  def failed?
    status == "Failed"
  end

  def running?
    !(completed? || failed?)
  end

  def unknown?
    status == "Unknown"
  end

  def in_progress?
    status = "InProgress"
  end

  def position
    @json[:positionInQueue]
  end

  def eta
    @json[:eta]
  end

  def started_time
    @json[:started]
  end

  def url_csv
    @json[:url]
  end

  def url_excel
    @json[:urlXlsx]
  end

  def url( format )
    (format.to_sym == :csv) ? url_csv : url_excel
  end

  def label
    (id || "")
      .gsub( /\A.*\//, "" )
      .gsub( ".csv", "" )
      .gsub( "-", " ")
  end
end
