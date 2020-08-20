module Surveys
  class BuildingTenuresController < ApplicationController
    def new
      @survey = survey
      @building_tenure = BuildingTenure.new(survey: survey)
    end

    def create
      @building_tenure = BuildingTenure.new create_building_tenure_params

      if @building_tenure.save
        redirect_to next_survey_section(current_section: @building_tenure, survey: survey)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def create_building_tenure_params
        params.require(:building_tenure).permit(:tenure_type).merge(survey: survey)
      end
  end
end
