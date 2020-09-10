module Surveys
  class BuildingWallMaterialsController < ApplicationController
    def new
      @survey = survey
      @section = section(@survey, "BuildingHeight")
      @building_wall_materials = BuildingWallMaterials.new(survey: @survey, building_wall: building_wall)
    end

    private

      def building_wall
        BuildingWall.find params[:id]
      end

      def survey
        Survey.find params[:survey_id]
      end
  end
end
