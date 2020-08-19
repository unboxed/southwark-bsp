require "rails_helper"

RSpec.describe "Landing page" do
  it "building manager lands on page" do
    building_manager = FactoryBot.create :building_manager
    building = FactoryBot.create :building, address: "1 ACME Studios", manager: building_manager

    visit start_survey_path(building_id: building.id)

    expect(page).to have_content building.address
    expect(page).to have_content building_manager.email
  end
end
