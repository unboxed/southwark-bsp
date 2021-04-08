require "rails_helper"
require "csv"

RSpec.describe "Admin can make bulk edits" do
  let!(:user) { create :user }

  before do
    building_list_fixture = file_fixture("building_record_list.csv")

    visit "/admin"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    click_on "Upload building list"

    attach_file "Upload a CSV file", building_list_fixture

    click_on "Upload"
  end

  it "can change on Delta property for multiple buildings" do
    selected_checkboxes = page.all("#building_building_id_").values_at(2, 4, 6)

    selected_checkboxes.each(&:check)

    selected_checkboxes.each do |checkbox|
      expect(checkbox).to be_checked
    end

    click_button "Mark as 'on Delta'"

    delta_cells = page.all(".delta").values_at(2, 4, 6)

    delta_cells.each do |cell|
      within(cell) do
        expect(page).to have_content("Yes")
      end
    end
  end
end
