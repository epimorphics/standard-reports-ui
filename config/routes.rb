# frozen_string_literal: true

Rails.application.routes.draw do
  root 'landing#index'
  resources 'landing', only: [:index]
  resource 'report-design', controller: :report_design, as: :report_design
  resource 'download-report', controller: :download_report, as: :download_report, only: [:show]

  get '*unmatched_route', to: 'application#render_404'
end
