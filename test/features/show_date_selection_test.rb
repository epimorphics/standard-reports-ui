# frozen_string_literal: true

require 'test_helper'

feature 'show date selection' do
  scenario 'visit the default tab to select dates' do
    VCR.use_cassette('latest_date_selection') do
      visit report_design_path(report: :avgPrice, areaType: 'country', area: 'EW', aggregate: 'county')
      _(page).must_have_css('.container h1')
      _(page).must_have_css('.container form[method=get]')
      _(page).must_have_css('.container .select-dates')
      _(page).must_have_css('.container input.button[type=submit]')

      %i[ytd latest_q latest_m].each do |period|
        _(page).must_have_css(".container input[type=checkbox][value=#{period}]")
      end
    end
  end
end
