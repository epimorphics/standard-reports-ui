# frozen_string_literal: true

require 'test_helper'

feature 'show post code area selector' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'pcArea')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-pc-area')
    _(page).must_have_css('.container input.button[type=submit]')
    _(page).must_have_css('.container input[type=text][name=area]')

    _(page).wont_have_css('.container p.flash')
  end

  scenario 'enter an invalid postcode' do
    visit report_design_path(report: :avgPrice, areaType: 'pcArea', area: 'womble')
    _(page).must_have_css('.container p.flash')
  end
end
