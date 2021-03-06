# frozen_string_literal: true

require 'test_helper'

feature 'show area aggregation selection' do
  scenario 'visit the workflow step page for country level report' do
    visit report_design_path(report: :avgPrice, areaType: 'country', area: 'EW')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-aggregation-type')
    _(page).must_have_css('.container input.button[type=submit]')

    %i[region county district pcDistrict pcSector].each do |area_type|
      _(page).must_have_css(".container input[type=radio][value=#{area_type}]")
    end

    %i[country pcArea].each do |area_type|
      _(page).wont_have_css(".container input[type=radio][value=#{area_type}]")
    end
  end

  scenario 'visit the workflow step page for chosen district report' do
    visit report_design_path(report: :avgPrice, areaType: 'district', area: 'MENDIP')
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
end
