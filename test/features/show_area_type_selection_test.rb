# frozen_string_literal: true

require 'test_helper'

feature 'show area type selection' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice)
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-area-type')
    _(page).must_have_css('.container input.button[type=submit]')

    %i[country region county district pcArea pcDistrict pcSector].each do |area_type|
      _(page).must_have_css(".container input[type=radio][value=#{area_type}]")
    end
  end
end
