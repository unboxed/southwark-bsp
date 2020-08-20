module Surveys
  class BuildingOwnershipsController < ApplicationController
    def new
      @survey = survey
      @ownership_information = BuildingOwnership.new(survey: @survey)
    end

    def create
      ownership_information = BuildingOwnership.new create_ownership_information_params
      if ownership_information.save
        redirect_to next_survey_section(current_section: ownership_information, survey: survey)
      end
    end

  private

    def survey
      Survey.find params[:survey_id]
    end

    def create_ownership_information_params
      params.require(:building_ownership).permit(:ownership_status).merge(survey: survey)
    end

    def next_survey_section(current_section:, survey:)
      SurveySequenceRouter.for(survey).next_section_for(current_section)
    end
  end
end
