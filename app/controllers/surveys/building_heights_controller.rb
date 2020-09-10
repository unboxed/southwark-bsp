module Surveys
  class BuildingHeightsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @previous_section = section(@survey, "BuildingOwnership")
      @building_height = BuildingHeight.new(survey: @survey)
    end

    def create
      building_height = survey.sections.build content: BuildingHeight.new(building_height_params)

      if building_height.save
        next_section = section(survey, "BuildingWall")
        redirect_to next_survey_section(current_section: building_height, survey: survey, next_section: next_section)
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @previous_section = section(@survey, "BuildingOwnership")
      @building_height = building_height
    end

    def update
      if building_height.update(building_height_params)
        if session[:previous_url] == survey_summary_url(survey)
          redirect_to survey_summary_path(survey)
        else
          next_section = section(survey, "BuildingWall")
          redirect_to next_survey_section(current_section: building_height.section, survey: survey, next_section: next_section)
        end
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_height
        BuildingHeight.find params[:id]
      end

      def building_height_params
        params.require(:building_height).permit(:higher_than_18_meters, :height_in_meters, :height_in_storeys).merge(survey: survey)
      end
  end
end
