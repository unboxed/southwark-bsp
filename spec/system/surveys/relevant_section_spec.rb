require "rails_helper"

# ##testing that user is redirected to the next relevant section after updating the answer coming from summary page

RSpec.describe "Building manager views survey reply summary" do
  context "modifing ownership, status and height" do
    let!(:building) do
      create :building
    end

    before do
      visit root_path
      click_on "Start now"
      fill_in with: building.uprn
      click_button "Continue"
    end

    it "redirects to the building_status section" do
      choose "I am not associated with this building", visible: false
      click_on "Continue"

      expect(page).to have_text("Check your answers")
      expect(building_ownership_row).to have_text("I am not associated with this building")

      within(building_ownership_row) { click_on "Change" }
      choose "Building owner freeholder", visible: false
      choose "Yes", visible: false
      fill_in "Name", with: "Ana"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Ana"

      click_on "Continue"

      expect(page).to have_text("Please confirm the status of this building")
    end

    it "redirects to the building_tenure section" do
      choose "Building owner freeholder", visible: false
      choose "Yes", visible: false
      fill_in "Name", with: "Ana"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Ana"
      click_on "Continue"
      choose "Demolished", visible: false
      click_on "Continue"

      expect(page).to have_text("Check your answers")
      expect(building_status_row).to have_text("Demolished")

      within(building_status_row) { click_on "Change" }
      choose "Existing", visible: false
      click_on "Continue"

      expect(page).to have_text("Please indicate the building use")
    end

    it "redirects to the building_walls section" do
      choose "Building owner freeholder", visible: false
      choose "Yes", visible: false
      fill_in "Name", with: "Ana"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Ana"
      click_on "Continue"
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"
      choose "No", visible: false
      click_on "Continue"

      expect(page).to have_text("Check your answers")
      expect(building_height_row).to have_text("Under 18 meters tall")

      within(building_height_row) { click_on "Change" }
      choose "Yes", visible: false
      click_on "Continue"

      expect(page).to have_text("External features of the building")
    end

    def building_ownership_row
      find('div[data-information-displayed="building-ownership"]')
    end

    def building_status_row
      find('div[data-information-displayed="building-status"]')
    end

    def building_height_row
      find('div[data-information-displayed="building-height"]')
    end
  end
end
