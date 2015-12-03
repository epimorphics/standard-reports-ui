require "test_helper"

feature "show county selection" do
  scenario "visit the workflow step page" do
    visit report_design_path( {report: :avgPrice, areaType: "county"} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .select-county" )
    page.must_have_css( ".container input.button[type=submit]")
    page.must_have_css( ".container input[type=text][name=area]")

    page.wont_have_css( ".container p.flash" )
  end

  scenario "enter an invalid county" do
    visit report_design_path( {report: :avgPrice, areaType: "county", area: "notacounty"} )
    page.must_have_css( ".container p.flash" )
  end
end
