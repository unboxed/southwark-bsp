require "rails_helper"

RSpec.describe "Building manager views survey reply summary" do
  it "in order to check the replies submitted" do
    building_manager = create :building_manager
    create :building, manager: building_manager

    visit root_path
    click_on "Start now"
    choose "Demolished", visible: false
    click_on "Continue"

    expect(page).to have_content "Check your answers"

    expect_building_status_to_be_displayed_as "Demolished"
  end

  def expect_building_status_to_be_displayed_as(status)
    expect(building_status_row).to have_text status
  end

  def building_status_row
    find('div[data-information-displayed="building-status"] dd')
  end
end
