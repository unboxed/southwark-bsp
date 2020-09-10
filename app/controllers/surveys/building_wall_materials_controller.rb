module Surveys
  class BuildingWallMaterialsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_wall_materials = BuildingWallMaterial.new(building_wall: building_wall)
    end

    def create
      byebug
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
        params.fetch(:building_wall_material, {})
      end
  end
end
