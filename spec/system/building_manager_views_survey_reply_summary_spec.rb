require "rails_helper"

RSpec.describe "Building manager views survey reply summary" do
  it "in order to check the replies submitted" do
    survey = create :survey
    building_status = create :building_status, status: "existing", survey: survey
    create :section, content: building_status, survey: survey
    building_ownership = create :building_ownership, ownership_status: "developer", survey: survey
    create :section, content: building_ownership, survey: survey
    building_tenure = create :building_tenure, tenure_type: "private_residential", survey: survey
    create :section, content: building_tenure, survey: survey
    building_height = create :building_height, higher_than_18_meters: true, height_in_storeys: 4, height_in_meters: 20, survey: survey
    create :section, content: building_height, survey: survey
    external_wall_structure = create :building_external_wall_structure, has_green_walls: true, survey: survey
    create :section, content: external_wall_structure, survey: survey

    visit survey_summary_path(survey)

    expect(page).to have_content "Check your answers"
    expect_building_status_to_be_displayed_as "Existing"
    expect_building_ownership_to_be_displayed_as "Developer"
    expect_building_tenure_to_be_displayed_as "Private residential"
    expect_building_height_to_be_displayed_as "Taller than 18 meters - 4 storey(s), 20 meters"
    expect_building_external_wall_structure_to_be_displayed_as "Green walls"

    within(building_ownership_row) { click_on "Change" }
    choose "Owner freeholder", visible: false
    click_on "Continue"

    expect_building_ownership_to_be_displayed_as "Owner freeholder"

    within(building_tenure_row) { click_on "Change" }
    choose "Social residential", visible: false
    click_on "Continue"

    expect_building_tenure_to_be_displayed_as "Social residential"

    within(building_height_row) { click_on "Change" }
    fill_in "In storeys", with: 3
    fill_in "In meters", with: 10
    click_on "Continue"

    expect_building_height_to_be_displayed_as "Taller than 18 meters - 3 storey(s), 10 meters"

    within(building_external_wall_structure_row) { click_on "Change" }
    check "Solar shading"
    uncheck "Green walls"
    click_on "Continue"

    expect_building_external_wall_structure_to_be_displayed_as "Solar shading"
  end

  def expect_building_status_to_be_displayed_as(status)
    expect(building_status_row).to have_text status
  end

  def expect_building_ownership_to_be_displayed_as(status)
    expect(building_ownership_row).to have_text status
  end

  def expect_building_tenure_to_be_displayed_as(status)
    expect(building_tenure_row).to have_text status
  end

  def expect_building_height_to_be_displayed_as(status)
    expect(building_height_row).to have_text status
  end

  def expect_building_external_wall_structure_to_be_displayed_as(status)
    expect(building_external_wall_structure_row).to have_text status
  end

  def building_status_row
    find('div[data-information-displayed="building-status"]')
  end

  def building_ownership_row
    find('div[data-information-displayed="building-ownership"]')
  end

  def building_tenure_row
    find('div[data-information-displayed="building-tenure"]')
  end

  def building_height_row
    find('div[data-information-displayed="building-height"]')
  end

  def building_external_wall_structure_row
    find('div[data-information-displayed="external-walls-structures"]')
  end
end
