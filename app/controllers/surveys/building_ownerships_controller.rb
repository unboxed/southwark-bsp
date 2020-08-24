module Surveys
  class BuildingOwnershipsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @section = section(@survey)
      @ownership_information = BuildingOwnership.new(survey: @survey)
    end

    def create
      ownership_information = survey.sections.build content: BuildingOwnership.new(building_ownership_params)
      if ownership_information.save
        redirect_to next_survey_section(current_section: ownership_information, survey: survey)
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @section = section(@survey)
      @ownership_information = building_ownership
    end

    def update
      if building_ownership.update building_ownership_params
        if session[:previous_url] == new_survey_building_height_url(survey)
          redirect_to new_survey_building_height_url(survey)
        else
          redirect_to survey_summary_path(survey)
        end
      end
    end

  private

    def survey
      Survey.find params[:survey_id]
    end

    def section(survey)
      survey.sections.find_by(content_type: "BuildingTenure")
    end

    def building_ownership
      BuildingOwnership.find params[:id]
    end

    def building_ownership_params
      params.require(:building_ownership).permit(:ownership_status).merge(survey: survey)
    end
  end
end
