require "rails_helper"

RSpec.describe "Building manager views survey reply summary" do
  context "modifing previous answers" do
    let!(:building_manager) do
      create :building_manager
    end
    let!(:building) do
      create :building, manager: building_manager
    end

    before do
      visit root_path
      click_on "Start now"
      fill_in with: building.uprn
      click_button "Continue"
    end

    it "allows managers to modify building status" do
       choose "Existing", visible: false
       click_on "Continue"

       expect(page).to have_link "Back"

       click_on "Back"

       expect(page).to have_text("Please confirm the status of this building")

       choose "Demolished", visible: false
       click_on "Continue"

       expect(page).to have_text("Check your answers")
     end

    it "allows managers to modify building tenure" do
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Please indicate the building use")

      choose "Private residential", visible: false

      click_on "Continue"

      expect(page).to have_text("Please confirm ownership status")
    end

    it "allows managers to modify building ownership" do
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"
      choose "Owner freeholder", visible: false
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Please confirm ownership status")

      choose "Developer", visible: false
      click_on "Continue"

      expect(page).to have_text("Is this building 18m or higher?")
    end

    it "allows managers to modify building height" do
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"
      choose "Owner freeholder", visible: false
      click_on "Continue"
      choose "Yes", visible: false
      within "fieldset", text: "If known, what is the height of this building?" do
        fill_in "In meters", with: 20
        fill_in "In storeys", with: 10
      end

      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Is this building 18m or higher?")
      choose "Yes", visible: false

      within "fieldset", text: "If known, what is the height of this building?" do
        fill_in "In meters", with: 22
        fill_in "In storeys", with: 11
      end

      click_on "Continue"

      expect(page).to have_text("External features of the building")
    end

    it "allows managers to modify the building's external materials" do
      survey = create :survey
      building_height = create :building_height, higher_than_18_meters: true, height_in_storeys: 4, height_in_meters: 20, survey: survey
      create :section, content: building_height, survey: survey
      building_wall = create :building_wall, survey: survey
      create :section, content: building_wall, survey: survey
      material_one = create :material, name: "Brick", percentage: "80", insulation_material: "None", building_wall: building_wall
      material_two = create :material, name: "Other",  percentage: "20", details: "Sheep", insulation_material: "Glass", building_wall: building_wall
      external_wall_structure = create :building_external_wall_structure, has_no_external_structures: true, survey: survey
      visit edit_survey_building_wall_path(survey_id: survey, id: building_wall)
      uncheck 'Brick'
      check 'Brick slips'

      uncheck 'Other'
      check 'Other'
      fill_in "Please describe the selected material", with: "Candy canes"
      click_on "Continue"

      fill_in "Brick slips", with: "40"
      fill_in "Other", with: "60"
      click_button "Continue"

      expect(page).to have_content "What insulation is used in combination with Brick slips?"
      choose "Brick slips.None", visible: false
      click_button "Continue"

      expect(page).to have_content "What insulation is used in combination with Other : Candy canes?"
      choose "Other.Glass wool", visible: false
      click_button "Continue"

      expect(page).to have_content "Brick slips - 40%, insulation: None Other Candy canes 60%, insulation: Glass wool"
    end
  end

  context "errors" do
    let!(:building_manager) do
      create :building_manager
    end
    let!(:building) do
      create :building, manager: building_manager
    end

    before do
      visit root_path
      click_on "Start now"
    end

    it "displays an error if uprn is incorrect" do
      fill_in with: 123
      click_button "Continue"

      expect(page).to have_text "There is a problem"
      expect(page).to have_text "Either you have not entered a UPRN number or the number you have entered is not correct."
      expect(page).to have_text "Please check the code provided on the letter or email."
    end

    it "displays an error if building_status not selected" do
      fill_in with: building.uprn
      click_button "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Status can't be blank. Please select one value from the list"
    end

    it "displays an error if building_tenure not selected" do
      fill_in with: building.uprn
      click_button "Continue"
      choose "Existing", visible: false
      click_on "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Tenure type can't be blank. Please select one value from the list"
    end

    it "displays an error if no building external wall options are selected" do
      survey = create(:survey)
      building_wall = create :building_wall, survey: survey
      create :section, content: building_wall, survey: survey
      visit new_survey_building_external_wall_structure_path(survey)

      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Please select at least one option"
    end
  end
end
