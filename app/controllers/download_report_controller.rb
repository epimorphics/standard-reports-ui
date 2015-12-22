class DownloadReportController < ApplicationController
  def show
    @report_manager = ReportManager.new( params: params )
    layout = !request.xhr? && "application"

    respond_to do |format|
      format.html { render :show, layout: layout }
      format.json { render json: @report_manager }
    end
  end
end
