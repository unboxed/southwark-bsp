module Surveys
  class BuildingExternalWallStructuresController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @section = section(@survey)
      @building_external_wall_structure = BuildingExternalWallStructure.new survey: @survey
    end

    def create
      @building_external_wall_structure = BuildingExternalWallStructure.new(external_structure_params)
      if @building_external_wall_structure.save
        survey.sections.create content: @building_external_wall_structure
        redirect_to next_survey_section(current_section: @building_external_wall_structure.section, survey: survey)
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
      @section = section(@survey)
      @building_external_wall_structure = building_external_wall_structure
    end

    def update
      @building_external_wall_structure = building_external_wall_structure
      if @building_external_wall_structure.update external_structure_params
        redirect_to next_survey_section(current_section: @building_external_wall_structure.section, survey: survey)
      else
        respond_to do |format|
          @survey = survey
          format.html { render :edit }
        end
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def section(survey)
        survey.sections.find_by(content_type: "BuildingWall")
      end

      def building_external_wall_structure
        BuildingExternalWallStructure.find params[:id]
      end

      def external_structure_params
        params.require(:building_external_wall_structure).permit(
          :has_balconies,
          :has_solar_shading,
          :has_green_walls,
          :has_no_external_structures,
          :has_other_structure,
          :other_structure_details
        ).merge(survey: survey)
      end
  end
end
