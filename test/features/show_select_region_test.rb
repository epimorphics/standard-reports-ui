# frozen_string_literal: true

require 'test_helper'

feature 'show region selection' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'region')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-region')
    _(page).must_have_css('.container input.button[type=submit]')

    StepSelectRegion::NAMES.each do |region|
      _(page).must_have_css(".container input[type=radio][value='#{region[1]}']")
    end
  end
end
