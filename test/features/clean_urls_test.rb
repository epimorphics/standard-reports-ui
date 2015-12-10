require "test_helper"

feature "hidden fields to propagate URL parameters do not contain extraneous information" do
  scenario "on a page part-way through the workflow" do
    visit report_design_path( {report: :avgPrice, areaType: "district"} )
    page.must_have_css( ".container input[type=hidden][name=report]")
    page.must_have_css( ".container input[type=hidden][name=areaType]")

    page.wont_have_css( ".container input[type=hidden][name=controller]" )
    page.wont_have_css( ".container input[type=hidden][name=action]" )
  end
end
