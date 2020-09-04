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

      expect(page).to have_text("Please indicate the primary tenure for this building")

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
      click_on "Continue"

      expect(page).to have_link "Back"

      click_on "Back"

      expect(page).to have_text("Is this building 18m or higher?")
      choose "Yes", visible: false

      within "fieldset", text: "If known, what is the height of this building?" do
        fill_in "In meters", with: 20
        fill_in "In storeys", with: 10
      end

      click_on "Continue"

      expect(page).to have_text("External facing materials")
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

    it "displays an error if building_status not selected" do
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Status can't be blank. Please select one value from the list"
    end

    it "displays an error if building_tenure not selected" do
      choose "Existing", visible: false
      click_on "Continue"
      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Tenure type can't be blank. Please select one value from the list"
    end

    it "displays an error if no building external wall options are selected" do
      survey = create(:survey)
      visit new_survey_building_external_wall_structure_path(survey)

      click_on "Continue"

      expect(page).to have_text "There was a problem with your survey"
      expect(page).to have_text "Please select at least one option"
    end
  end
end
