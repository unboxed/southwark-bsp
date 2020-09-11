module Surveys
  class BuildingWallMaterialsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_wall_material = BuildingWallMaterial.new(building_wall: building_wall)
    end

    def create
      building_wall_materials =  building_wall_material_params[:material_name].each do |m|
         BuildingWallMaterial.create(material_name: m, building_wall: building_wall)
      end
      if building_wall_materials
        redirect_to new_survey_building_wall_building_wall_material_percentage_path(survey, building_wall_id: building_wall)
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

      def survey
        Survey.find params[:survey_id]
      end

      def building_wall_material_params
        params.require(:building_wall_material).permit(:other_material, material_name: [])
      end
  end
end
