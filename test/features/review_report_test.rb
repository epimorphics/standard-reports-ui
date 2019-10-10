# frozen_string_literal: true

require 'test_helper'

feature 'review the report summary' do
  scenario 'visit the workflow step page' do
    visit report_design_path(report: :avgPrice, areaType: 'country', area: 'EW', aggregate: 'none', period: ['ytd'], age: 'any')
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container .review-report')
    _(page).must_have_css('.container input.button[type=submit]')
    _(page).must_have_css('.container ul.c-review-report')

    %i[report areaType aggregate 'period[]' age].each do |param|
      _(page).must_have_css(".container input[name=#{param}]", visible: :hidden)
    end
  end
end
