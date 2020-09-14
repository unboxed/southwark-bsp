module Surveys
  class PercentagesController < ApplicationController
    def new
      @building_wall = building_wall
      @materials = building_wall.materials
      @survey = survey
      @previous_section = building_wall.id
    end

    def create
      percentages = percentage_params[:percentage].each do |key, val|
        Percentage.create(material_id: key, material_percentage: val)
      end
      if !percentages.blank?
        if insulation_section_complete?
          redirect_to survey_summary_path(survey)
        else
          redirect_to new_survey_building_wall_insulation_path(survey: survey, building_wall: building_wall)
        end
      end
    end

    private

      def percentage_params
        params.permit({ percentage: {} },
          :material_percentage,
          :material_id,
          :authenticity_token,
          :commit,
          :survey_id,
          :building_wall_id)
      end

      def survey
        Survey.find params[:survey_id]
      end

      def building_wall
        BuildingWall.find params[:building_wall_id]
      end

      def all_materials_needing_insulation
        building_wall.materials.find { |m| m.insulation == nil }
      end

      def insulation_section_complete?
        all_materials_needing_insulation.blank?
      end
  end
end
