require "rails_helper"

RSpec.describe SurveySequenceRouter, "#next_section_for" do
  include Rails.application.routes.url_helpers

  it "returns the survey summary path if the current section should terminate the survey" do
    survey = build_stubbed :survey
    content = build_stubbed :building_status, status: "demolished"
    next_section = nil
    section = build_stubbed :section, content: content, survey: survey

    next_section_path = SurveySequenceRouter.for(survey).next_section_for(section.content, next_section)

    expect(next_section_path).to eq survey_summary_path(survey)
  end

  it "returns the survey building tenure path if the current section is 'BuildingStatus'" do
    survey = build_stubbed :survey
    content = build_stubbed :building_status, status: "existing"
    next_section = nil
    section = build_stubbed :section, content: content, survey: survey

    next_section_path = SurveySequenceRouter.for(survey).next_section_for(section.content, next_section)

    expect(next_section_path).to eq new_survey_building_tenure_path(survey)
  end

  it "returns the survey building height path if the current section is 'BuildingTenure'" do
    survey = build_stubbed :survey
    content = build_stubbed :building_tenure
    next_section = nil
    section = build_stubbed :section, content: content, survey: survey

    next_section_path = SurveySequenceRouter.for(survey).next_section_for(section.content, next_section)

    expect(next_section_path).to eq new_survey_building_height_path(survey)
  end
end
