# frozen_string_literal: true

require 'test_helper'

feature 'can commence report design process' do
  scenario 'initial page content' do
    visit report_design_path
    page.must_have_css('.container h1')
    page.must_have_css('.container form[method=get]')
    page.must_have_css('.container input#report_avgPrice')
    page.must_have_css('.container input#report_banded')
    page.must_have_css('.container input.button[type=submit]')
    page.must_have_css('.container .select-report')
  end
end
