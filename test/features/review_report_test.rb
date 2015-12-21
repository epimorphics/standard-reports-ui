require "test_helper"

feature "review the report summary" do
  scenario "visit the workflow step page" do
    visit report_design_path( {report: :avgPrice, areaType: "country", aggregate: "none", period: ["ytd"], age: "any"} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .review-report" )
    page.must_have_css( ".container input.button[type=submit]")
    page.must_have_css( ".container ul.c-review-report" )

    %i{ report areaType aggregate 'period[]' age }.each do |param|
      page.must_have_css( ".container input[type=hidden][name=#{param}]")
    end
  end
end
