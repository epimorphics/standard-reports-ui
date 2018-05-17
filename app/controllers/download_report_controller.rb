# frozen_string_literal: true

# Controller for downloading reports
class DownloadReportController < ApplicationController
  def show
    layout = whole_page?(params) && 'application'
    @report_manager = ReportManager.new(params: params)

    respond_to do |format|
      format.html { render :show, layout: layout }
      format.json { render json: @report_manager }
    end
  end

  private

  def partial_page?(params)
    params.delete('_partial')
  end

  def whole_page?(params)
    !partial_page?(params)
  end
end
