module Surveys
  class ExternalWallsMaterialDetailsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @previous_section = section(@survey, "BuildingExternalWallStructure")
      @external_wall_structure = external_wall_structure
      @material_detail_list = MaterialDetailList.new(
        external_structure_name: required_detail,
        building_external_wall_structure: @external_structure
      )
    end

    def create
      material_detail_list = MaterialDetailList.new detail_list_params
      if material_detail_list.save
        next_section = nil
        redirect_to next_survey_section(current_section: external_wall_structure.section, survey: survey, next_section: next_section)
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @previous_section = section(@survey, "BuildingExternalWallStructure")
      @external_wall_structure = external_wall_structure
      @material_detail_list = material_detail_list
    end

    def update
      if material_detail_list.update detail_list_params
        next_section = nil
        redirect_to next_survey_section(current_section: external_wall_structure.section, survey: survey, next_section: next_section)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def external_wall_structure
        BuildingExternalWallStructure.find params[:building_external_wall_structure_id]
      end

      def required_detail
        params.fetch :required_detail
      end

      def material_detail_list
        MaterialDetailList.find params[:id]
      end

      def detail_list_params
        params.require(:material_detail_list).permit(
          :has_timber_or_wood_primary_material,
          :has_timber_or_wood_floor_material,
          :has_timber_or_wood_railing_material,
          :has_glass_primary_material,
          :has_glass_floor_material,
          :has_glass_railing_material,
          :has_metal_primary_material,
          :has_metal_floor_material,
          :has_metal_railing_material,
          :has_concrete_primary_material,
          :has_concrete_floor_material,
          :has_concrete_railing_material,
          :has_unknown_primary_material,
          :has_unknown_floor_material,
          :has_unknown_railing_material,
          :has_other_primary_material,
          :has_other_floor_material,
          :has_other_railing_material,
          :other_primary_material_details,
          :other_floor_material_details,
          :other_railing_material_details,
        ).merge(
          external_structure_name: required_detail,
          building_external_wall_structure: external_wall_structure
        )
      end
  end
end
