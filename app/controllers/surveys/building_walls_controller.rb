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
        @previous_section = section(survey, "BuildingHeight")
        next_section = section(survey, "BuildingWallMaterial")
        redirect_to new_survey_building_wall_building_wall_material_path(survey, building_wall_id: building_wall)
        # there are problems with creating the next section for some reason
        # redirect_to next_survey_section(current_section: building_wall.section, survey: survey, next_section: nil)
      end
    end

    private

    def building_walls_params
      params.permit(:material_quantity).merge(survey: survey)
    end

    def survey
      Survey.find params[:survey_id]
    end

    def building_wall
      BuildingWall.find params[:id]
    end
  end
end
