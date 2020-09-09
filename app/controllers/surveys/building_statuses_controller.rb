module Surveys
  class BuildingStatusesController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @previous_section = section(@survey, "BuildingOwnership")
      @building_status = BuildingStatus.new(survey: @survey)
    end

    def create
      building_status = BuildingStatus.new(building_status_params)
      if building_status.save
        next_section = section(survey, "BuildingTenure")
        survey.sections.create content: building_status
        redirect_to next_survey_section(current_section: building_status.section, survey: survey, next_section: next_section)
      else
        respond_to do |format|
          @building_status = building_status
          @survey = survey
          @previous_section = section(@survey, "BuildingOwnership")
          format.html { render :new  }
          format.json { render json: @building_status.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @building_status = building_status
      @previous_section = section(@survey, "BuildingOwnership")
    end

    def update
      if building_status.update building_status_params
        if session[:previous_url] == survey_summary_url(survey)
          redirect_to survey_summary_path(survey)
        else
          next_section = section(survey, "BuildingTenure")
          redirect_to next_survey_section(current_section: building_status.section, survey: survey, next_section: next_section)
        end
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
