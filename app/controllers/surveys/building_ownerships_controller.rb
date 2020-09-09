module Surveys
  class BuildingOwnershipsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @ownership_information = BuildingOwnership.new(survey: @survey)
    end

    def create
      ownership_information = survey.sections.build content: BuildingOwnership.new(building_ownership_params)
      if ownership_information.save
        next_section = section(survey, "BuildingStatus")
        redirect_to next_survey_section(current_section: ownership_information, survey: survey, next_section: next_section)
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @ownership_information = building_ownership
    end

    def update
      if building_ownership.update building_ownership_params
        if session[:previous_url] == survey_summary_url(survey)
          redirect_to survey_summary_path(survey)
        else
          next_section = section(survey, "BuildingStatus")
          redirect_to next_survey_section(current_section: building_ownership.section, survey: survey, next_section: next_section)
        end
      end
    end

  private

    def survey
      Survey.find params[:survey_id]
    end

    def building_ownership
      BuildingOwnership.find params[:id]
    end

    def building_ownership_params
      params.require(:building_ownership).permit(:ownership_status, :right_to_manage_company, :full_name, :email, :organisation).merge(survey: survey)
    end
  end
end
