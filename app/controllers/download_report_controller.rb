# frozen_string_literal: true

# Controller for downloading reports
class DownloadReportController < ApplicationController
  def show
    layout = whole_page?(params) && 'application'
    @report_manager = ReportManager.new(params: params)

    if @report_manager.valid?
      render_report(layout)
    else
      render_not_valid(layout)
    end
  end

  private

  def partial_page?(params)
    params.delete('_partial')
  end

  def whole_page?(params)
    !partial_page?(params)
  end

  def render_report(layout)
    respond_to do |format|
      format.html { render :show, layout: layout }
      format.json { render json: @report_manager }
    end
  end

  def render_not_valid(layout)
    respond_to do |format|
      format.html { render :bad_request, layout: layout, status: :bad_request }
      format.json { render json: {}, status: :bad_request }
    end
  end
end
