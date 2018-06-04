# frozen_string_literal: true

require 'test_helper'

feature 'show post code sector selector' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector')
    page.must_have_css('.container h1')
    page.must_have_css('.container form[method=get]')
    page.must_have_css('.container .select-pc-sector')
    page.must_have_css('.container input.button[type=submit]')
    page.must_have_css('.container input[type=text][name=area]')

    page.wont_have_css('.container p.flash')
  end

  scenario 'enter an invalid postcode' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector', area: 'womble')
    page.must_have_css('.container p.flash')
  end

  scenario 'visit the workflow step page for chosen postcode sector report' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector', area: 'BA6 8')
    page.must_have_css('.container h1')
    page.must_have_css('.container form[method=get]')
    page.must_have_css('.container .select-aggregation-type')
    page.must_have_css('.container input.button[type=submit]')

    %i[none].each do |area_type|
      page.must_have_css(".container input[type=radio][value=#{area_type}]")
      page.must_have_css(".container input[type=radio][value=#{area_type}][checked=checked]")
    end

    %i[country region district pcArea pcDistrict psSector pcArea].each do |area_type|
      page.wont_have_css(".container input[type=radio][value=#{area_type}]")
    end
  end

  scenario 'when stopping on an invalid value the step number is correct' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector', area: '57', aggregate: 'none', period: ['ytd'], age: 'any')
    page.must_have_content('Step 3 of 7')
  end
end
