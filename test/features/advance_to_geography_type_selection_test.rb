require "test_helper"

feature "can advance to geography type select" do
  scenario "select report type and submit" do
    visit report_design_path
    choose "Average prices and volumes"
    click_button "Next"
    page.must_have_css( ".select-geography-type" )
  end
end
