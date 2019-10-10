# frozen_string_literal: true

require 'test_helper'

feature 'show post code sector selector' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-pc-sector')
    _(page).must_have_css('.container input.button[type=submit]')
    _(page).must_have_css('.container input[type=text][name=area]')

    _(page).wont_have_css('.container p.flash')
  end

  scenario 'enter an invalid postcode' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector', area: 'womble')
    _(page).must_have_css('.container p.flash')
  end

  scenario 'visit the workflow step page for chosen postcode sector report' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector', area: 'BA6 8')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-aggregation-type')
    _(page).must_have_css('.container input.button[type=submit]')

    %i[none].each do |area_type|
      _(page).must_have_css(".container input[type=radio][value=#{area_type}]")
      _(page).must_have_css(".container input[type=radio][value=#{area_type}][checked=checked]")
    end

    %i[country region district pcArea pcDistrict psSector pcArea].each do |area_type|
      _(page).wont_have_css(".container input[type=radio][value=#{area_type}]")
    end
  end

  scenario 'when stopping on an invalid value the step number is correct' do
    visit report_design_path(report: :avgPrice, areaType: 'pcSector', area: '57', aggregate: 'none', period: ['ytd'], age: 'any')
    _(page).must_have_content('Step 3 of 7')
  end
end
