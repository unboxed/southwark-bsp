require "rails_helper"

RSpec.describe "Landing page" do
  it "building manager lands on page" do
    building = FactoryBot.create :building, address: "1 ACME Studios"

    visit start_survey_path(building_id: building.id)

    expect(page).to have_content building.address
  end
end
