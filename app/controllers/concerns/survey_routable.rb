module SurveyRoutable
  extend ActiveSupport::Concern

  def next_survey_section(current_section:, survey:, next_section:)
    SurveySequenceRouter.for(survey).next_section_for(current_section.content, next_section)
  end

  def section(survey, section)
    survey.sections.find_by(content_type: section)
  end
end
