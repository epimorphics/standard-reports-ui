class DownloadReportController < ApplicationController
  def show
    @report_manager = ReportManager.new( params: params )
  end
end
