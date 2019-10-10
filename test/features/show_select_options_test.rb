# frozen_string_literal: true

require 'test_helper'

feature 'show options selection' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'country', area: 'EW', aggregate: 'none', period: 'ytd')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .select-options')
    _(page).must_have_css('.container input.button[type=submit]')

    %i[any old new].each do |age|
      _(page).must_have_css(".container input[type=radio][value=#{age}]")
    end
  end
end
