require "rails_helper"

RSpec.describe "building manager fills in survey", js: true do
  it "answers the questions" do
    building_manager = create :building_manager
    building = create :building, manager: building_manager

    visit start_survey_path(for: building)
    click_link "Start now"
    choose "Existing", visible: false
    click_button "Continue"
    choose "Social residential", visible: false
    click_button "Continue"
  end
end
