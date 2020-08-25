require 'rails_helper'

RSpec.describe "Building manager functionality" do
  let!(:building_manager) do
    create :building_manager
  end
  let!(:building) do
    create :building, manager: building_manager
  end

  before do
    visit root_path
  end

  context "filling in a survey" do
    it "creates a new survey" do
      expect(page).to have_text("Building safety survey")

      click_on "Start now"
      expect(page).to have_text("Please confirm the status of this building")
    end

    it "allows a building manager to fill in the complete building information" do
      click_link "Start now"
      choose "Existing", visible: false
      click_button "Continue"
      expect(page).to have_text("Please indicate the primary tenure for this building")

      choose "Social residential", visible: false
      click_button "Continue"
      expect(page).to have_text("Please confirm ownership status")

      choose "Owner freeholder", visible: false
      click_button "Continue"

      expect(page).to have_text("Is this building 18m or higher?")
      choose "Yes", visible: false
      click_button "Continue"

      expect(page).to have_text("If known, what is the height of this building?")
      fill_in "In meters", with: 20
      fill_in "In storeys", with: 9
      click_button "Continue"

      expect(page).to have_content "External facing materials"
      check "Glass", visible: false
      check "Brick slips", visible: false
      check "Other", visible: false
      fill_in "Please describe the selected material", with: "Potatoes"

      click_button "Continue"

      expect(page).to have_content "What percentage of the total external wall area of the building does this material cover?"
      expect(page).to have_content "Glass"
      expect(page).to have_content "Brick slips"
      expect(page).to have_content "Potatoes"

      fill_in "Glass", with: "20"
      fill_in "Brick slips", with: "40"
      fill_in "Other", with: "40"
      click_button "Continue"

      expect(page).to have_content "What insulation is used in combination with Glass?"
      check "Glass.Phenolic foam insulation", visible: false
      click_button "Continue"

      expect(page).to have_content "What insulation is used in combination with Brick slips?"
      check "Brick slips.Expanded and Extruded polystyrene (EPS/XPS)", visible: false
      click_button "Continue"

      expect(page).to have_content "What insulation is used in combination with Other : Potatoes?"
      check "Other.Wood fibre", visible: false
      click_button "Continue"

      expect(page).to have_content "Are there any sizeable external wall structures?"
      check "Has no external structures"
      click_button "Continue"

      expect(page).to have_content "Check your answers"
    end
  end
end
