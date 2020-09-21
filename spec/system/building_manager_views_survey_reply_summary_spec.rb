require "rails_helper"

RSpec.describe "Building manager views survey reply summary" do
  it "in order to check the replies submitted" do
    survey = create :survey
    building_status = create :building_status, status: "existing", survey: survey
    create :section, content: building_status, survey: survey
    building_ownership = create :building_ownership, ownership_status: "building_developer", full_name: "Pepe", email: "test@test.com", organisation: "Pepe&Co", survey: survey
    create :section, content: building_ownership, survey: survey
    building_tenure = create :building_tenure, tenure_type: "private_residential", survey: survey
    create :section, content: building_tenure, survey: survey
    building_wall = create :building_wall, survey: survey
    create :section, content: building_wall, survey: survey
    building_height = create :building_height, higher_than_18_meters: true, height_in_storeys: 4, height_in_meters: 20, survey: survey
    create :section, content: building_height, survey: survey
    building_wall = create :building_wall, survey: survey
    create :section, content: building_wall, survey: survey
    material_one = create :material, building_wall: building_wall, name: "Brick"
    percentage_one = create :percentage, material: material_one
    insulation_one = create :insulation, insulation_material: "Pompons", material: material_one, insulation_details: "glass turkeys"
    material_two = create :material, building_wall: building_wall, name: "Other", details: "Fudge"
    percentage_two = create :percentage, material: material_two
    insulation_two = create :insulation, material: material_two, insulation_material: "Glass", insulation_details: "porcelain chickens"

    external_wall_structure = create :building_external_wall_structure, has_balconies: true, has_solar_shading: true, has_green_walls: true, survey: survey
    create :section, content: external_wall_structure, survey: survey
    create(
      :material_detail_list,
      building_external_wall_structure: external_wall_structure,
      external_structure_name: "balcony",
      has_timber_or_wood_primary_material: true,
      has_glass_primary_material: true,
      has_concrete_floor_material: true,
      has_metal_railing_material: true
    )
    create(
      :material_detail_list,
      building_external_wall_structure: external_wall_structure,
      external_structure_name: "solar_shading",
      has_glass_primary_material: true,
      has_metal_primary_material: true
    )

    visit survey_summary_path(survey)

    expect(page).to have_content "Check your answers"
    expect(page).to have_content "Building details"
    expect(page).to have_content "A place full of wonders"
    expect(page).to have_content "1 Union Street"
    expect(page).to have_content "London"
    expect(page).to have_content "NW1235"
    expect(page).to have_content "UPRN"
    expect(page).to have_content "#{survey.building.uprn}"
    expect_building_status_to_be_displayed_as "Existing"
    expect_building_ownership_to_be_displayed_as "Building developer"
    expect_building_tenure_to_be_displayed_as "Private residential"
    expect_building_height_to_be_displayed_as "Taller than 18 meters - 20 meters 4 storey(s)"
    expect_building_external_wall_structure_to_be_displayed_as "Green walls"
    expect(page).to have_content "Number of materials"
    expect(page).to have_content "2"
    expect(page).to have_content "Brick - 50%, insulation: Pompons Other Fudge 50%, insulation: Glass"

    within(building_ownership_row) { click_on "Change" }
    choose "Building owner freeholder", visible: false
    click_on "Continue"

    expect_building_ownership_to_be_displayed_as "Building owner freeholder"

    within(building_tenure_row) { click_on "Change" }
    choose "Social residential", visible: false
    click_on "Continue"

    expect_building_tenure_to_be_displayed_as "Social residential"

    within(building_height_row) { click_on "Change" }
    fill_in "In storeys (optional)", with: 3
    fill_in "In metres (optional)", with: 10
    click_on "Continue"

    expect_building_height_to_be_displayed_as "Taller than 18 meters - 10 meters 3 storey(s)"

    within(building_external_wall_structure_row) { click_on "Change" }
    uncheck "Green walls", visible: false
    click_on "Continue"

    expect_building_external_wall_structure_to_be_displayed_as "Solar shading"
    expect_balcony_structure_to_be_displayed_as "Primary materials: Timber or wood, Glass Floor materials: Concrete Railings/balustrades: Metal"
    expect_solar_shading_structure_to_be_displayed_as "Glass, Metal"

    within(balcony_structure_row) { click_on "Change" }
    within(balcony_primary_materials_row) { uncheck "Glass" }
    click_on "Continue"

    expect_balcony_structure_to_be_displayed_as "Primary materials: Timber or wood Floor materials: Concrete Railings/balustrades: Metal"

    within(solar_shading_structure_row) { click_on "Change" }
    within(solar_shading_floor_materials_row) { check "Concrete" }
    click_on "Continue"

    expect_solar_shading_structure_to_be_displayed_as "Glass, Metal, Concrete"
  end

  it "in order to check not relevant replies were deleted" do
    survey = create :survey
    building_status = create :building_status, status: "existing", survey: survey
    create :section, content: building_status, survey: survey
    building_ownership = create :building_ownership, ownership_status: "building_developer", full_name: "Pepe", email: "test@test.com", organisation: "Pepe&Co", survey: survey
    create :section, content: building_ownership, survey: survey
    building_tenure = create :building_tenure, tenure_type: "private_residential", survey: survey
    create :section, content: building_tenure, survey: survey
    building_height = create :building_height, higher_than_18_meters: true, height_in_storeys: 4, height_in_meters: 20, survey: survey
    create :section, content: building_height, survey: survey
    building_wall = create :building_wall, survey: survey
    create :section, content: building_wall, survey: survey
    material_one = create :material, building_wall: building_wall, name: "Brick"
    percentage_one = create :percentage, material: material_one
    insulation_one = create :insulation, insulation_material: "Pompons", material: material_one, insulation_details: "porcelain chickens"
    material_two = create :material, building_wall: building_wall, name: "Other", details: "Fudge"
    percentage_two = create :percentage, material: material_two
    insulation_two = create :insulation, material: material_two, insulation_material: "Glass", insulation_details: "porcelain chickens"

    external_wall_structure = create :building_external_wall_structure, has_balconies: true, has_solar_shading: true, has_green_walls: true, survey: survey
    create :section, content: external_wall_structure, survey: survey
    create(
      :material_detail_list,
      building_external_wall_structure: external_wall_structure,
      external_structure_name: "balcony",
      has_timber_or_wood_primary_material: true,
      has_glass_primary_material: true,
      has_concrete_floor_material: true,
      has_metal_railing_material: true
    )
    create(
      :material_detail_list,
      building_external_wall_structure: external_wall_structure,
      external_structure_name: "solar_shading",
      has_glass_primary_material: true,
      has_metal_primary_material: true
    )

    visit survey_summary_path(survey)

    within(building_height_row) { click_on "Change" }
    choose "No", visible: false
    click_on "Continue"

    expect_building_height_to_be_displayed_as "Under 18 meters tall - 20 meters 4 storey(s)"
    expect(page).not_to have_content("Building wall")
    expect(page).not_to have_content("External walls structures")

    within(building_status_row) { click_on "Change" }
    choose "Demolished", visible: false
    click_on "Continue"

    expect_building_status_to_be_displayed_as "Demolished"
    expect(page).not_to have_content("Building tenure")
    expect(page).not_to have_content("Building height")

    within(building_ownership_row) { click_on "Change" }
    choose "I am not associated with this building", visible: false
    click_on "Continue"

    expect_building_ownership_to_be_displayed_as "I am not associated with this building"
    expect(page).not_to have_content("Building tenure")
    expect(page).not_to have_content("Building status")
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

  def expect_balcony_structure_to_be_displayed_as(status)
    expect(balcony_structure_row).to have_text status
  end

  def expect_solar_shading_structure_to_be_displayed_as(status)
    expect(solar_shading_structure_row).to have_text status
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

  def solar_shading_material_row
    find('div[data-materials="solar-shading-primary"]')
  end

  def balcony_structure_row
    find('div[data-information-displayed="external-structure-balcony"]')
  end

  def solar_shading_structure_row
    find('div[data-information-displayed="external-structure-solar-shading"]')
  end

  def balcony_primary_materials_row
    find('div[data-materials="balcony-primary"]')
  end

  def solar_shading_floor_materials_row
    find('div[data-materials="solar-shading-primary"]')
  end
end
