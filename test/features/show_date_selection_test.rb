require "test_helper"

feature "show date selection" do
  scenario "visit the default tab to select dates" do
    visit report_design_path( {rt: :avgPrice, areaType: "country", aggregate: "county"} )
    page.must_have_css( ".container h1" )
    page.must_have_css( ".container form[method=get]" )
    page.must_have_css( ".container .select-dates" )
    page.must_have_css( ".container input.button[type=submit]")

    %i{ ytd latest_q latest_m }.each do |period|
      page.must_have_css( ".container input[type=checkbox][value=#{period}]")
    end

  end
end
