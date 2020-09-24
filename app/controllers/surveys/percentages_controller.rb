module Surveys
  class PercentagesController < ApplicationController
    def new
      @building_wall = building_wall
      @materials = building_wall.materials
      @survey = survey
      @previous_section = building_wall.id
    end

    def create
      @error = nil
      @building_wall = building_wall
      @materials = building_wall.materials
      @survey = survey
      @previous_section = building_wall.id

      percentages = percentage_params[:percentage]

      percentages_created = percentage_params[:percentage].to_h.map do |key, val|
        Percentage.create(material_id: key, material_percentage: val)
      end

      if percentages_created.any? { |p| !p.errors.empty? }
        @error = "Please provide percentage for all materials"
        percentages_created.each { |p| p.try(:destroy) }
        render :new
        return
      elsif percentages_created.sum(&:material_percentage) != 100
        @error = "Percentage does not equal 100%. Please fill in percentages again to total 100%."
        percentages_created.each { |p| p.try(:destroy) }
        render :new
        return
      end

      if !percentages.blank?
        if !insulation_section_complete?
          redirect_to new_survey_building_wall_insulation_path(survey: survey, building_wall: building_wall)
        elsif insulation_section_complete? && balconies_and_insulations_incomplete?
          redirect_to new_survey_building_external_wall_structure_path(survey)
        else
          redirect_to survey_summary_path(survey)
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

      def balconies_and_insulations_incomplete?
        external_structure = BuildingExternalWallStructure.find_by(survey_id: survey.id)
        if external_structure.blank?
          return true
        elsif external_structure.has_no_external_structures?
          return false
        elsif external_structure.solar_shading_material_detail_list.blank? || external_structure.balcony_material_detail_list.blank?
          return true
        end

        false
      end
  end
end
