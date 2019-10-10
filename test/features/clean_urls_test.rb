# frozen_string_literal: true

require 'test_helper'

feature 'hidden fields to propagate URL parameters do not contain extraneous information' do
  scenario 'on a page part-way through the workflow' do
    visit report_design_path(report: :avgPrice, areaType: 'district')
    _(page).must_have_css('.container input[name=report]', visible: :hidden)
    _(page).must_have_css('.container input[name=areaType]', visible: :hidden)

    _(page).wont_have_css('.container input[name=controller]', visible: :hidden)
    _(page).wont_have_css('.container input[name=action]', visible: :hidden)
  end
end
