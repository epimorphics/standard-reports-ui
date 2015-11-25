require "test_helper"

feature "can commence report design process" do
  scenario "initial page content" do
    visit report_design_path
    Rails.logger.debug "page = #{page.inspect}"
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container input#rt_avgPrice" )
    page.must_have_css( ".container input#rt_banded" )
    page.must_have_css( ".container input.button[type=submit]")
  end
end
