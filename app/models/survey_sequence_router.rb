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
    return survey_summary_path(survey) if current_section.should_terminate_survey?

    case current_section.class.name
    when "BuildingStatus"
      new_survey_building_tenure_path(survey)
    when "BuildingTenure"
      new_survey_building_ownership_path(survey)
    when "BuildingOwnership"
      new_survey_building_height_path(survey)
    when "BuildingHeight"
      if current_section.incomplete?
        survey_meters_and_storeys_path(survey)
      else
        new_survey_building_wall_material_path(survey)
      end
    when "Materials"
      new_survey_building_external_wall_structure_path(survey)
    when "BuildingExternalWallStructure"
      if current_section.incomplete?
        new_survey_building_external_wall_structure_material_detail_list_path(
          survey,
          current_section,
          required_detail: current_section.next_required_detail
        )
      else
        survey_summary_path(survey)
      end
    end
  end
end
