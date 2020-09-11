module Surveys
  class BuildingWallMaterialInsulationsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_wall_material_insulation = BuildingWallMaterialInsulation.new
      @material = building_wall_materials.first
      @options_for_insulation = insulations
    end

    def create
      byebug
      building_wall_material_insulations =  BuildingWallMaterialInsulation.new(building_wall_material_insulation_params)
      building_wall_material_insulations.save
        if building_wall_material_insulations.complete?
          redirect_to survey_building_wall_building_wall_material_percentages_path(survey, building_wall_id: building_wall)
        else
          redirect_to new_survey_building_wall_building_wall_material_insulation_path(survey, building_wall_id: building_wall)
        end
    end

    def edit
    end

    def update
    end

    private

      def building_wall
        BuildingWall.find params[:building_wall_id]
      end

      def building_wall_materials
        building_wall.building_wall_materials
      end

      def survey
        Survey.find params[:survey_id]
      end

      def building_wall_material_insulation_params
        params.require(:building_wall_material).permit(:percentage)
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
