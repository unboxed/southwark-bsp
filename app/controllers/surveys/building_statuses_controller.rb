module Surveys
  class BuildingStatusesController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_status = BuildingStatus.new(survey: @survey)
    end

    def create
      building_status = survey.sections.build content: BuildingStatus.new(building_status_params)

      if building_status.save
        redirect_to next_survey_section(current_section: building_status, survey: survey)
      end
    end

    def edit
      @survey = survey
      @building_status = building_status
    end

    def update
      if building_status.update building_status_params
        redirect_to survey_summary_path(survey)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_status_params
        params.require(:building_status).permit(:status).merge(survey: survey)
      end

      def building_status
        BuildingStatus.find params[:id]
      end
  end
end
