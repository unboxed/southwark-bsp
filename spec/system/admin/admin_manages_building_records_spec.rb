require "rails_helper"
require "csv"

RSpec.describe "Admin manages building records" do
  let!(:user) { create :user }

  it "importing records via CSV upload" do
    building_list_fixture = file_fixture("building_record_list.csv")
    parsed_building_list_fixture = CSV.parse building_list_fixture.read, headers: true

    visit "/admin"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    visit new_admin_bulk_import_path

    attach_file "Upload a CSV file", building_list_fixture

    click_on "Upload"

    expect(page).to have_content parsed_building_list_fixture.first["uprn"]
    expect(page).to have_content parsed_building_list_fixture.first["pao"]
  end
end
