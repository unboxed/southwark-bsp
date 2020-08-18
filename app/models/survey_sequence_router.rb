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
    in "BuildingStatus"
      new_survey_building_tenure_path(survey)
    in "BuildingTenure"
      new_survey_building_ownership_contacts_path(survey)
    end
  end
end
