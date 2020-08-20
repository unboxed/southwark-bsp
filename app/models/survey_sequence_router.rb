class SurveySequenceRouter
  include Rails.application.routes.url_helpers

  attr_reader :survey

  def self.for(survey)
    new(survey)
  end

  def initialize(survey)
    @survey = survey
  end

  def next_section_for(current_section)
    return end_survey_path(survey) if current_section.should_terminate_survey?

    case current_section.class.name
    when "BuildingStatus"
      new_survey_building_tenure_path(survey)
    when "BuildingTenure"
      new_survey_building_ownership_path(survey)
    when "BuildingOwnership"
      new_survey_building_height_path(survey)
    when "BuildingHeight"
      survey_meters_and_storeys_path(survey)
    end
  end
end
