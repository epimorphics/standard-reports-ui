# frozen_string_literal: true

require 'test_helper'

feature 'existing user selections are shown in state of input controls' do
  scenario 'report type page' do
    visit report_design_path(report: 'avgPrice', stop: 'report')
    _(page).must_have_css('.container input[name=report][value=avgPrice][checked=checked]')
  end

  scenario 'area type page' do
    visit report_design_path(report: 'avgPrice', areaType: 'country', stop: 'areaType')
    _(page).must_have_css('.container input[name=areaType][value=country][checked=checked]')
    visit report_design_path(report: 'avgPrice', areaType: 'region', stop: 'areaType')
    _(page).must_have_css('.container input[name=areaType][value=region][checked=checked]')
    visit report_design_path(report: 'avgPrice', areaType: 'district', stop: 'areaType')
    _(page).must_have_css('.container input[name=areaType][value=district][checked=checked]')
  end

  scenario 'region page' do
    visit report_design_path(report: 'avgPrice', areaType: 'region', area: 'NORTH', stop: 'area')
    _(page).must_have_css('.container input[name=area][value=NORTH][checked=checked]')
  end

  scenario 'county page' do
    visit report_design_path(report: 'avgPrice', areaType: 'county', area: 'DEVON', stop: 'area')
    _(page).must_have_css('.container input[name=area][value=DEVON]')
  end

  scenario 'district page' do
    visit report_design_path(report: 'avgPrice', areaType: 'district', area: 'MENDIP', stop: 'area')
    _(page).must_have_css('.container input[name=area][value=MENDIP]')
  end

  scenario 'postcode area page' do
    visit report_design_path(report: 'avgPrice', areaType: 'pcArea', area: 'TA', stop: 'area')
    _(page).must_have_css('.container input[name=area][value=TA]')
  end

  scenario 'postcode district page' do
    visit report_design_path(report: 'avgPrice', areaType: 'pcDistrict', area: 'TA6', stop: 'area')
    _(page).must_have_css('.container input[name=area][value=TA6]')
  end

  scenario 'postcode sector page' do
    visit report_design_path(report: 'avgPrice', areaType: 'pcSector', area: 'TA6 1', stop: 'area')
    _(page).must_have_css(".container input[name=area][value='TA6 1']")
  end

  scenario 'aggregation page' do
    visit report_design_path(report: 'avgPrice', areaType: 'county', area: 'DEVON', aggregate: 'district', stop: 'aggregate')
    _(page).must_have_css('.container input[name=aggregate][value=district]')
  end

  scenario 'dates page' do
    VCR.use_cassette('latest_available_dates') do
      visit report_design_path(report: 'avgPrice', areaType: 'county', area: 'DEVON', aggregate: 'district', period: %w[ytd 2014 2014-Q1 2014-01], stop: 'period')
      _(page).must_have_css(".container input[name='period[]'][value=ytd][checked=checked]", visible: false)
      _(page).must_have_css(".container input[name='period[]'][value='2014'][checked=checked]", visible: false)
      _(page).must_have_css(".container input[name='period[]'][value='2014-Q1'][checked=checked]", visible: false)
      _(page).must_have_css(".container input[name='period[]'][value='2014-01'][checked=checked]", visible: false)
    end
  end

  scenario 'options page' do
    visit report_design_path(report: 'avgPrice', areaType: 'county', area: 'DEVON', aggregate: 'district', period: ['ytd'], age: 'new', stop: 'age')
    _(page).must_have_css(".container input[name='age'][value=new][checked=checked]")
  end
end
