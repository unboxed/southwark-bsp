module Surveys
  class BuildingStatusesController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_information = BuildingStatus.new(survey: @survey)
    end

    def create
      building_status = survey.sections.build content: BuildingStatus.new(create_building_status_params)

      if building_status.save
        redirect_to next_survey_section(current_section: building_status, survey: survey)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def create_building_status_params
        params.require(:building_status).permit(:status).merge(survey: survey)
      end
  end
end
