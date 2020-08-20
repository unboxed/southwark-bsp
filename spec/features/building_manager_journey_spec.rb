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

    it "sets building statuses" do
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
    end
  end
end
