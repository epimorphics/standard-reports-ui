# frozen_string_literal: true

# :nodoc:
class LandingController < ApplicationController
  def index
    Log.info('Landing Controller', { params: params, path: request.path })
  end
end
