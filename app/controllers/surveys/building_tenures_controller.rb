module Surveys
  class BuildingTenuresController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_tenure = BuildingTenure.new(survey: survey)
    end

    def create
      @building_tenure = survey.sections.build content: BuildingTenure.new(building_tenure_params)

      if @building_tenure.save
        redirect_to next_survey_section(current_section: @building_tenure, survey: survey)
      end
    end

    def edit
      @survey = survey
      @building_tenure = building_tenure
    end

    def update
      if building_tenure.update building_tenure_params
        redirect_to survey_summary_path(survey)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_tenure
        BuildingTenure.find params[:id]
      end

      def building_tenure_params
        params.require(:building_tenure).permit(:tenure_type).merge(survey: survey)
      end
  end
end
