# frozen_string_literal: true

require 'test_helper'

feature 'can advance to area type select' do
  scenario 'select report type and submit' do
    visit report_design_path
    choose 'Average prices and volumes'
    click_button 'Next'
    _(page).must_have_css('.select-area-type')
  end
end
