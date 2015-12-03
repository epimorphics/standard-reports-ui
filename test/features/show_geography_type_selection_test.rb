require "test_helper"

feature "show geography type selection" do
  scenario "visit the workflow step page" do
    visit report_design_path( {report: :avgPrice} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .select-geography-type" )
    page.must_have_css( ".container input.button[type=submit]")

    %i{ country region county district postcode }.each do |area_type|
      page.must_have_css( ".container input[type=radio][value=#{area_type}]")
    end
  end
end
