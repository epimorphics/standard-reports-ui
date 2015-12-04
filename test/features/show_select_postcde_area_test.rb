require "test_helper"

feature "show post code area selector" do
  scenario "visit the workflow step page" do
    visit report_design_path( {report: :avgPrice, areaType: "pcArea"} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .select-pc-area" )
    page.must_have_css( ".container input.button[type=submit]")
    page.must_have_css( ".container input[type=text][name=area]")

    page.wont_have_css( ".container p.flash" )
  end

  scenario "enter an invalid postcode" do
    visit report_design_path( {report: :avgPrice, areaType: "pcArea", area: "womble"} )
    page.must_have_css( ".container p.flash" )
  end
end
