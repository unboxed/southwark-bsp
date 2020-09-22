require "rails_helper"
### testing that back_links take you back to previous section and allow to modify answers
### testing error messages if required fields are not selected

RSpec.describe "Building manager views survey reply summary" do
  context "modifing previous answers" do
    let!(:building) do
      create :building
    end

    before do
      visit root_path
      click_on "Start now"
      fill_in with: building.uprn
      click_button "Continue"
    end

    it "allows managers to modify building ownership" do
      choose "Building owner freeholder", visible: false
      fill_in "Name", with: "Pepito"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Pepito&Co"

      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Your relationship to the building")

      choose "Building developer", visible: false
      choose "Yes", visible: false

      fill_in "Name", with: "Ana"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Ana"

      click_on "Continue"

      expect(page).to have_text("Please confirm the status of this building")
    end


    it "allows managers to modify building status" do
       choose "Building owner freeholder", visible: false
       fill_in "Name", with: "Pepito"
       fill_in "Email", with: "test@test.com"
       fill_in "Organisation", with: "Pepito&Co"
       click_on "Continue"
       choose "Existing", visible: false
       within "fieldset", text: "Can you provide more detail?" do
         fill_in "status_details", with: "I really want some apple pie"
       end

       click_on "Continue"

       expect(page).to have_link "Back"

       click_on "Back"

       expect(page).to have_text("Please confirm the status of this building")
       expect(page).to have_text("I really want some apple pie")

       choose "Demolished", visible: false
       click_on "Continue"

       expect(page).to have_text("Check your answers")
     end

    it "allows managers to modify building tenure" do
      choose "Building owner freeholder", visible: false
      fill_in "Name", with: "Pepito"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Pepito&Co"
      click_on "Continue"
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Please indicate the building use")

      choose "Private residential", visible: false

      click_on "Continue"

      expect(page).to have_text("Is this building 18m or higher?")
    end

    it "allows managers to modify building height" do
      choose "Building owner freeholder", visible: false
      fill_in "Name", with: "Pepito"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Pepito&Co"
      click_on "Continue"
      choose "Existing", visible: false
      click_on "Continue"
      choose "Social residential", visible: false
      click_on "Continue"
      choose "Yes", visible: false
      within "fieldset", text: "How tall is the building?" do
        fill_in "In metres (optional)", with: 20
        fill_in "In storeys (optional)", with: 10
      end

      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Is this building 18m or higher?")
      choose "Yes", visible: false

      within "fieldset", text: "How tall is the building?" do
        fill_in "In metres (optional)", with: 22
        fill_in "In storeys (optional)", with: 11
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
      fill_in "insulation_details", with: "feathers"
      click_button "Continue"

      expect(page).to have_content "What insulation is used in combination with Other : Candy canes?"
      choose "Other.Glass wool", visible: false
      fill_in "insulation_details", with: "donuts"
      click_button "Continue"

      expect(page).to have_content "Brick slips - 40%, insulation: None Other Candy canes 60%, insulation: Glass wool"
    end
  end

  context "errors" do
    let!(:building) do
      create :building
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

    it "displays an error if building_ownership not selected" do
      fill_in with: building.uprn
      click_button "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Select your role as either building owner, freeholder, building developer, managing agent, other, or if you are not associated with this building"
    end

    it "displays an error if building_ownership is selected but name/email and organisation is blank" do
      fill_in with: building.uprn
      click_button "Continue"
      choose "Building owner freeholder", visible: false
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Please provide contact details"
    end

    it "displays an error if building_status not selected" do
      fill_in with: building.uprn
      click_button "Continue"
      choose "Building owner freeholder", visible: false
      fill_in "Name", with: "Pepito"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Pepito&Co"
      click_on "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Status can't be blank. Please select one value from the list"
    end

    it "displays an error if building_tenure not selected" do
      fill_in with: building.uprn
      click_button "Continue"
      choose "Building owner freeholder", visible: false
      fill_in "Name", with: "Pepito"
      fill_in "Email", with: "test@test.com"
      fill_in "Organisation", with: "Pepito&Co"
      click_on "Continue"
      choose "Existing", visible: false
      click_on "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Please select one value from the list"
    end

    it "displays an error if no building insulation options are selected" do
      survey = create(:survey)
      building_height = create :building_height, higher_than_18_meters: true, height_in_storeys: 4, height_in_meters: 20, survey: survey
      create :section, content: building_height, survey: survey
      building_wall = create :building_wall, survey: survey
      create :section, content: building_wall, survey: survey
      material = create :material, building_wall: building_wall, name: "Glass"

      visit new_survey_building_wall_insulation_path(survey_id: survey.id, building_wall_id: building_wall.id)

      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Insulation material can't be blank"
      expect(page).to have_text "Please select one value from the list"
      expect(page).to have_text "Insulation details can't be blank"
      expect(page).to have_text "Please provide further details in the comment box"
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


    it "displays an error if no value was provided for percentages" do
      survey = create(:survey)
      building_height = create(:building_height, higher_than_18_meters: true, survey: survey)
      create :section, content: building_height, survey: survey
      visit survey_building_walls_path(survey)
      click_on "Continue"
      check "Glass"
      check "Metal sheet panels"
      click_on "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Please provide percentage for all materials"
    end

    it "displays an error if sum of percentage provided is not equal 100" do
      survey = create(:survey)
      building_height = create(:building_height, higher_than_18_meters: true, survey: survey)
      create :section, content: building_height, survey: survey
      visit survey_building_walls_path(survey)
      click_on "Continue"
      check "Glass"
      check "Metal sheet panels"
      click_on "Continue"
      fill_in "Glass", with: 500
      fill_in "Metal sheet panels", with: 70
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Percentage does not add to 100"
    end
  end
end
