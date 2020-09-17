module Surveys
  class BuildingHeightsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @previous_section = section(@survey, "BuildingTenure")
      @building_height = BuildingHeight.new(survey: @survey)
    end

    def create
      @building_height = BuildingHeight.new(building_height_params)

      if @building_height.save
        next_section = section(survey, "BuildingWall")
        survey.sections.create content: @building_height
        redirect_to next_survey_section(current_section: @building_height.section, survey: survey, next_section: next_section)
      else
        respond_to do |format|
          @survey = survey
          format.html { render :new }
        end
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @previous_section = section(@survey, "BuildingTenure")
      @building_height = building_height
    end

    def update
      before_update = building_height.higher_than_18_meters?
      if building_height.update(building_height_params)
        if !before_update && building_height.higher_than_18_meters?
          next_section = section(survey, "BuildingWall")
          redirect_to next_survey_section(current_section: building_height.section, survey: survey, next_section: next_section)
        elsif session[:previous_url] == survey_summary_url(survey)
          next_section = section(survey, "BuildingWall")
          delete_not_relevant_info(current_section: building_height.section, next_section: next_section)
          redirect_to survey_summary_path(survey)
        else
          next_section = section(survey, "BuildingWall")
          redirect_to next_survey_section(current_section: building_height.section, survey: survey, next_section: next_section)
        end
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_height
        BuildingHeight.find params[:id]
      end

      def building_height_params
        params.require(:building_height).permit(:higher_than_18_meters, :height_in_meters, :height_in_storeys).merge(survey: survey)
      end
  end
end
