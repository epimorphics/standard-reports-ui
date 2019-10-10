# frozen_string_literal: true

require 'test_helper'

feature 'show county selection' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'county')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-county')
    _(page).must_have_css('.container input.button[type=submit]')
    _(page).must_have_css('.container input[type=text][name=area]')

    _(page).wont_have_css('.container p.flash')
  end

  scenario 'enter an invalid county' do
    visit report_design_path(report: :avgPrice, areaType: 'county', area: 'notacounty')
    _(page).must_have_css('.container p.flash')
  end
end
