class SurveySequenceRouter
  include Rails.application.routes.url_helpers
  include SurveyRoutable

  attr_reader :survey

  def self.for(survey)
    new(survey)
  end

  def initialize(survey)
    @survey = survey
  end

  def building_wall
    survey.sections.find_by(content_type: "BuildingWall").content_id
  end

  def next_section_for(current_section, next_section)
    return survey_summary_path(survey) if current_section.should_terminate_survey?

    case current_section.class.name
    when "BuildingOwnership"
      if next_section != nil
        edit_survey_building_status_path(survey.id, next_section.content_id)
      else
        new_survey_building_status_path(survey)
      end
    when "BuildingStatus"
      if next_section != nil
        edit_survey_building_tenure_path(survey.id, next_section.content_id)
      else
        new_survey_building_tenure_path(survey)
      end
    when "BuildingTenure"
      if next_section != nil
        edit_survey_building_height_path(survey.id, next_section.content_id)
      else
        new_survey_building_height_path(survey)
      end
    when "BuildingHeight"
        survey_building_walls_path(survey)
    when "BuildingWalls"
        new_survey_building_wall_building_wall_material_path(survey, building_wall_id: building_wall)
    when "BuildingWallMaterials"
      if next_section != nil
        new_survey_building_wall_building_wall_material_percentage_path(survey.id, next_section.content_id, material.id)
      else
        edit_survey_building_wall_building_wall_material_percentage_path(survey, building_wall_id: building_wall)
      end
    when "BuildingWallPercentages"
      if next_section != nil
        edit_survey_building_wall_building_wall_material_insulation_path(survey.id, next_section.content_id, material.id)
      else
        new_survey_building_wall_building_wall_material_insulation_path(survey, building_wall_id: building_wall)
      end
    when "BuildingWallInsulations"
      if next_section != nil
        edit_survey_building_external_wall_structure_material_detail_list_path(survey.id, next_section.content_id, material.id)
      else
        new_survey_building_external_wall_structure_material_detail_list_path(survey, building_wall_id: building_wall)
      end
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
