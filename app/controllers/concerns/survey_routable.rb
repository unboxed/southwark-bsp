module SurveyRoutable
  extend ActiveSupport::Concern

  def next_survey_section(current_section:, survey:)
    SurveySequenceRouter.for(survey).next_section_for(current_section.content)
  end
end
