require 'rails_helper'

RSpec.describe "Building manager functionality" do
  context "filling in a survey" do
    it "allows the building manager to start a new survey" do
      building = create :building

      visit root_path
      expect(page).to have_text("Tall buildings survey")

      click_on "Start now"

      expect(page).to have_text(building.address)
    end
  end
end
