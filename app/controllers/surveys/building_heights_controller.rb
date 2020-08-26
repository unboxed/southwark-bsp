module Surveys
  class BuildingHeightsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @section = section(@survey)
      @building_height = BuildingHeight.new(survey: @survey)
    end

    def create
      building_height = survey.sections.build content: BuildingHeight.new(building_height_params)

      if building_height.save
        redirect_to next_survey_section(current_section: building_height, survey: survey)
      end
    end

    def meters_and_storeys
      @survey = survey
      @building_height = BuildingHeight.find_by(survey_id: survey)
    end

    def edit
      @survey = survey
      @section = section(@survey)
      @building_height = building_height
    end

    def update
      building_height = BuildingHeight.find_by(survey_id: survey)

      if building_height.update(building_height_params)
        redirect_to survey_summary_path(building_height.survey)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def section(survey)
        survey.sections.find_by(content_type: "BuildingOwnership")
      end

      def building_height
        BuildingHeight.find params[:id]
      end

      def building_height_params
        params.require(:building_height).permit(:higher_than_18_meters, :height_in_meters, :height_in_storeys).merge(survey: survey)
      end
  end
end
