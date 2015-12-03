require "test_helper"

feature "show region selection" do
  scenario "visit the workflow step page" do
    visit report_design_path( {report: :avgPrice, areaType: "region"} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .select-region" )
    page.must_have_css( ".container input.button[type=submit]")

    StepSelectRegion::NAMES.each do |region|
      page.must_have_css( ".container input[type=radio][value='#{region}']")
    end
  end
end
