# frozen_string_literal: true

require 'test_helper'

feature 'can commence report design process' do
  scenario 'initial page content' do
    visit report_design_path
    _(page).must_have_css('.container h1')
    _(page).must_have_css('.container form[method=get]')
    _(page).must_have_css('.container input#report_avgPrice')
    _(page).must_have_css('.container input#report_banded')
    _(page).must_have_css('.container input.button[type=submit]')
    _(page).must_have_css('.container .select-report')
  end
end
