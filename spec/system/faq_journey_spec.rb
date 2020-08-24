require 'rails_helper'

RSpec.describe "Building manager functionality" do
  context "going through FAQ" do
    it "allows the user to visit the FAQ page" do
      manager = create :building_manager
      building = create :building, manager: manager

      visit root_path
      click_on "frequently asked questions"

      expect(page).to have_text("Frequently asked questions ")
    end
  end
end
