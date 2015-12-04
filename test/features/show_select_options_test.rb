require "test_helper"

feature "show area type selection" do
  scenario "visit the workflow step page" do
    visit report_design_path( {report: :avgPrice, areaType: "country", aggregate: "none", period: "ytd"} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .select-options" )
    page.must_have_css( ".container input.button[type=submit]")

    %i{ any old new }.each do |age|
      page.must_have_css( ".container input[type=radio][value=#{age}]")
    end
  end
end
