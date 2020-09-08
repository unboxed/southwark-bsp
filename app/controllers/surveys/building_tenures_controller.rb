module Surveys
  class BuildingTenuresController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @section = section(@survey, "BuildingStatus")
      @building_tenure = BuildingTenure.new(survey: survey)
    end

    def create
      building_tenure = BuildingTenure.new(building_tenure_params)
      if building_tenure.save
        next_section = section(survey, "BuildingOwnership")
        survey.sections.create content: building_tenure
        redirect_to next_survey_section(current_section: building_tenure.section, survey: survey, next_section: next_section)
      else
        respond_to do |format|
          @building_tenure = building_tenure
          @survey = survey
          @section = section(@survey, "BuildingStatus")
          format.html { render :new }
        end
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @section = section(@survey, "BuildingStatus")
      @building_tenure = building_tenure
    end

    def update
      if building_tenure.update building_tenure_params
        if session[:previous_url] == survey_summary_url(survey)
          redirect_to survey_summary_path(survey)
        else
          next_section = section(survey, "BuildingOwnership")
          redirect_to next_survey_section(current_section: building_tenure.section, survey: survey, next_section: next_section)
        end
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
