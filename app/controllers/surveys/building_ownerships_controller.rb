module Surveys
  class BuildingOwnershipsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @building_ownership = BuildingOwnership.new(survey: @survey)
    end

    def create
      building_ownership = BuildingOwnership.new(building_ownership_params)
      if building_ownership.save
        next_section = section(survey, "BuildingStatus")
        survey.sections.create content: building_ownership
        redirect_to next_survey_section(current_section: building_ownership.section, survey: survey, next_section: next_section)
      else
        @building_ownership = building_ownership
        @survey = survey
        render :new
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @building_ownership = building_ownership
    end

    def update
      before_update = building_ownership.ownership_status
      owner = building_ownership
      if owner.update building_ownership_params
        if before_update == "i_am_not_associated_with_this_building" && building_ownership.ownership_status != "i_am_not_associated_with_this_building"
          next_section = section(survey, "BuildingStatus")
          redirect_to next_survey_section(current_section: building_ownership.section, survey: survey, next_section: next_section)
        elsif
          session[:previous_url] == survey_summary_url(survey)
          next_section = section(survey, "BuildingStatus")
          delete_not_relevant_info(current_section: building_ownership.section, next_section: next_section)
          redirect_to survey_summary_path(survey)
        else
          next_section = section(survey, "BuildingStatus")
          redirect_to next_survey_section(current_section: building_ownership.section, survey: survey, next_section: next_section)
        end
      else
        @building_ownership = owner
        @survey = survey
        render :edit
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
