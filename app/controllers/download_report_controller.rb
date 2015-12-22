class DownloadReportController < ApplicationController
  def show
    @report_manager = ReportManager.new( params: params )

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @report_manager }
    end
  end
end
