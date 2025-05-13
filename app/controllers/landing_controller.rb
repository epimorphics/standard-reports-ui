# frozen_string_literal: true

# :nodoc:
class LandingController < ApplicationController
  def index
    LoggingHelper.log_request({ params: params, path: request.path }, 'info')
  end
end
