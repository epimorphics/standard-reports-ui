# frozen_string_literal: true

require 'test_helper'

feature 'hidden fields to propagate URL parameters do not contain extraneous information' do
  scenario 'on a page part-way through the workflow' do
    visit report_design_path(report: :avgPrice, areaType: 'district')
    page.must_have_css('.container input[name=report]', visible: :hidden)
    page.must_have_css('.container input[name=areaType]', visible: :hidden)

    page.wont_have_css('.container input[name=controller]', visible: :hidden)
    page.wont_have_css('.container input[name=action]', visible: :hidden)
  end
end
