require "rails_helper"

RSpec.describe "External wall structures section" do
  it "building manager indicates building's external attachments" do
    survey = create :survey
    previous_section = create :section, content: create(:building_wall, survey: survey), survey: survey

    visit new_survey_building_external_wall_structure_path(survey)

    expect(page).to have_content "Are there any sizeable external wall structures?"

    check "Balconies", visible: false
    check "Solar shading", visible: false
    check "Other", visible: false
    fill_in "Please list other external structures", with: "Parrots. Lots of them."
    click_on "Continue"

    expect(page).to have_content "Balcony materials"

    within(balcony_primary_material_section) do
      check "Timber or wood"
    end

    within(balcony_floor_material_section) do
      check "Concrete"
    end

    within(balcony_railing_material_section) do
      check "Metal"
      check "Do not know"
      check "Other"
      fill_in "Please list other railing/balustrade materials for the balcony. Separate these by commas.", with: "Praline truffles"
    end

    click_on "Continue"

    expect(page).to have_content "Solar shading material"

    check "Metal"
    check "Do not know"
    check "Other"
    fill_in "Please list other materials for the solar shading, separated by commas", with: "Minky whales"

    click_on "Continue"

    expect(page).to have_content "Check your answers"
    expect_building_external_wall_structure_to_be_displayed_as "Balconies, Solar shading"
  end

  def expect_building_external_wall_structure_to_be_displayed_as(status)
    expect(building_external_wall_structure_row).to have_text status
  end

  def building_external_wall_structure_row
    find('div[data-information-displayed="external-walls-structures"]')
  end

  def balcony_primary_material_section
    find('div[data-materials="balcony-primary"]')
  end

  def balcony_floor_material_section
    find('div[data-materials="balcony-floors"]')
  end

  def balcony_railing_material_section
    find('div[data-materials="balcony-railings"]')
  end
end
