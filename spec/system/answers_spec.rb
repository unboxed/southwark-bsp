require "rails_helper"

RSpec.describe "Building manager views survey reply summary" do
  context "modifing previous answers" do
    let!(:building_manager) do
      create :building_manager
    end
    let!(:building) do
      create :building, manager: building_manager
    end

    before do
      visit root_path
      click_on "Start now"
    end

    it "allows managers to modify building status" do
       choose "Existing", visible: false
       click_on "Continue"

       expect(page).to have_link "Back"

       click_on "Back"

       expect(page).to have_text("Please confirm the status of this building")

       choose "Demolished", visible: false
       click_on "Continue"

       expect(page).to have_text("Check your answers")
     end

    it "allows managers to modify building tenure" do
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Please indicate the primary tenure for this building")

      choose "Private residential", visible: false

      click_on "Continue"

      expect(page).to have_text("Please confirm ownership status")
    end

    it "allows managers to modify building ownership" do
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"
      choose "Owner freeholder", visible: false
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Please confirm ownership status")

      choose "Developer", visible: false
      click_on "Continue"

      expect(page).to have_text("Is this building 18m or higher?")
    end

    it "allows managers to modify building height" do
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"
      choose "Owner freeholder", visible: false
      click_on "Continue"
      choose "Yes", visible: false
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Is this building 18m or higher?")
      expect(page).to have_text("If known, what is the height of this building?")

      choose "No", visible: false
      click_on "Continue"

      expect(page).to have_text("Check your answers")
    end
  end
end
