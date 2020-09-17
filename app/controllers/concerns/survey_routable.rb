module SurveyRoutable
  extend ActiveSupport::Concern

  def next_survey_section(current_section:, survey:, next_section:)
    SurveySequenceRouter.for(survey).next_section_for(current_section.content, next_section)
  end

  def section(survey, section)
    survey.sections.find_by(content_type: section)
  end

  def delete_not_relevant_info(current_section:, next_section:)
    return if next_section == nil
    return if next_section != nil && !current_section.should_terminate_survey?

    case current_section.name
    when "Building ownership"
      content_type_to_destroy = ["BuildingStatus", "BuildingTenure", "BuildingHeight", "BuildingWall", "Materials", "BuildingExternalWallStructure"]
      survey.sections.where(content_type: content_type_to_destroy).each { |section| section.try(:destroy) }
    when "Building status"
      content_type_to_destroy = ["BuildingTenure", "BuildingHeight", "BuildingWall", "Materials", "BuildingExternalWallStructure"]
      survey.sections.where(content_type: content_type_to_destroy).each { |section| section.try(:destroy) }
    when "Building height"
      content_type_to_destroy = ["BuildingWall", "Materials", "BuildingExternalWallStructure"]
      survey.sections.where(content_type: content_type_to_destroy).each { |section| section.try(:destroy) }
    else
      nil
    end
  end
end
