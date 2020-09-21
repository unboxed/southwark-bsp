module Surveys
  class InsulationsController < ApplicationController
    def new
      @options_for_insulation = insulations
      @material = all_materials_needing_insulation
      @survey = survey
      @previous_section = building_wall.id
      @insulations = Insulation.new
    end

    def create
      if params_are_not_present?
        @material = all_materials_needing_insulation
        @insulations = Insulation.new(material_id: @material.id)
        @insulations.valid?
        @options_for_insulation = insulations
        @survey = survey
        @previous_section = building_wall
        render :new
      else
        insulation_params[:insulation_material].each do |key, val|
          insulation = Insulation.new(material_id: key, insulation_material: val, insulation_details: insulation_params[:insulation_details])
          if insulation.save
            redirect_to_next_section
          else
            respond_to do |format|
              @insulations = insulation
              @options_for_insulation = insulations
              @material = all_materials_needing_insulation
              @survey = survey
              @previous_section = building_wall
              format.html { render :new  }
            end
          end
        end
      end
    end

    private

      def insulation_params
        params.permit(
          :insulation,
          { insulation_material: {} },
          :insulation_details,
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

      def next_section_incomplete?
        BuildingExternalWallStructure.find_by(survey_id: survey.id).blank?
      end

      def redirect_to_next_section
        if insulation_section_complete? && !next_section_incomplete?
          redirect_to survey_summary_path(survey)
        elsif insulation_section_complete? && next_section_incomplete?
          redirect_to new_survey_building_external_wall_structure_path(survey)
        else
          redirect_to new_survey_building_wall_insulation_path(survey: survey, building_wall: building_wall)
        end
      end

      def params_are_not_present?
        insulation_params[:insulation_material].blank?
      end

      def insulations
        [
          "Polyurethane rigid foam (PUR) or Polyisocyanurate foam (PIR)",
          "Phenolic foam insulation",
          "Expanded and Extruded polystyrene (EPS/XPS)",
          "Glass wool", "Wood fibre", "Mineral wool",
          "None", "Do not know", "Other"
        ]
      end
  end
end
