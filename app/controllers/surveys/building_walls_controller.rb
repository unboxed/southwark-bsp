module Surveys
  class BuildingWallsController < ApplicationController
    include SurveyRoutable

    def index
      @survey = survey
      @previous_section = section(@survey, "BuildingHeight")
    end

    def create
      building_wall = BuildingWall.new(building_walls_params)
      if building_wall.save
        survey.sections.create content: building_wall
        redirect_to new_survey_building_wall_material_path(survey, building_wall_id: building_wall)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_walls_params
        params.permit(:material_quantity).merge(survey: survey)
      end
  end
end
