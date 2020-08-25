module Surveys
  class MaterialsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @section = section(@survey)
      @building_wall_materials = building_wall
    end

    def update
      if params[:building_wall][:percentage]
        params[:building_material].each { |key, val|  Material.find_by_id(key).update(percentage: val) }
        redirect_to survey_building_wall_materials_details_path(survey_id: survey.id, building_wall_id: building_wall.id)
      elsif params[:building_wall][:insulation]
        params[:building_material].each { |key, val|  Material.find_by_id(key).update(insulation_material: val) }
        if insulation_section_complete?
          redirect_to new_survey_building_external_wall_structure_path(survey)
        else
          redirect_to survey_building_wall_materials_details_path(survey_id: survey.id, building_wall_id: building_wall.id)
        end
      end
    end

    def material_partial
      @building_wall = building_wall
      @options_for_insulation = insulations
      @material = all_materials.first
      if insulation_section_complete?
        redirect_to new_survey_building_external_wall_structure_path(survey)
      else
        render "insulation_material"
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_wall
        BuildingWall.find params[:building_wall_id]
      end

      def section(survey)
        survey.sections.find_by(content_type: "BuildingWall")
      end

      def all_materials
        building_wall.materials.where(insulation_material: nil)
      end

      def insulation_section_complete?
        all_materials.blank?
      end

      def insulations
        [
          "Polyurethane rigid foam (PUR) or Polyisocyanurate foam (PIR)",
          "Phenolic foam insulation",
          "Expanded and Extruded polystyrene (EPS/XPS)",
          "Glass wool", "Wood fibre", "Mineral wool",
          "None", "Do not know", "Other"
        ]
      end
  end
end
