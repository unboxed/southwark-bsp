require "rails_helper"
require "csv"

RSpec.describe "Admin manages building records" do
  it "importing records via CSV upload" do
    user = create :user
    building_list_fixture = file_fixture("building_record_list.csv")
    parsed_building_list_fixture = CSV.parse building_list_fixture.read, headers: true

    visit "/admin"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"
    click_on "Upload building list"

    attach_file "Upload a CSV file", building_list_fixture

    click_on "Upload"

    expect(page).to have_content parsed_building_list_fixture.first["uprn"]
    expect(page).to have_content parsed_building_list_fixture.first["pao"]
  end

  it "adding a building record" do
    user = create :user

    visit "/admin"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"
    click_on "Add a building record"
    fill_in "UPRN", with: "0987654321"
    fill_in "Building name", with: "ACME Central"
    fill_in "Building street", with: "1, Dynamite Lane"
    fill_in "Building postcode", with: "SE23 3HH"
    fill_in "Proprietor name", with: "Coyote Developments"
    fill_in "Proprietor email", with: "beepbeep@example.com"
    fill_in "Proprietor address", with: "Runner Building, 34, Boom Street, ACME 12, NeverLand"
    click_on "Add building"

    expect(page).to have_content "0987654321"
    expect(page).to have_content "Runner Building, 34, Boom Street, ACME 12, NeverLand"
  end
end
