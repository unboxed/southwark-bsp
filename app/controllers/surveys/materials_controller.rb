module Surveys
  class MaterialsController < ApplicationController
    include SurveyRoutable

    def new
      @survey = survey
      @previous_section = section(@survey, "BuildingHeight")
      @options_for_materials = materials
      @building_wall = building_wall
    end

    def create
      material = material_params[:materials].each do |material|
        if material == "Other"
          Material.create(name: "Other", details: material_params[:details], building_wall_id: building_wall.id)
        else
          Material.create(name: material, building_wall_id: building_wall.id)
        end
      end

      if !material.blank?
        building_wall.update(material_quantity: building_wall.materials.count)
        redirect_to new_survey_building_wall_percentage_path(building_wall_id: building_wall)
      end
    end

    def edit
      @survey = survey
      @previous_section = section(@survey, "BuildingHeight")
      @options_for_materials = materials
      @building_wall = building_wall
      @other_material = building_wall.materials.where(name: "Other").pluck(:details)
    end

    def update
      material = material_params[:materials].each do |material|
        if material == "Other"
          Material.find_or_create_by(name: material, details: material_params[:details], building_wall_id: building_wall.id)
        else
          Material.find_or_create_by(name: material, building_wall_id: building_wall.id)
        end
      end

      building_wall.materials.map { |obj| obj.destroy unless material_params[:materials].include?(obj.name) }
      duplicate_other = building_wall.materials.where(name: "Other")
      duplicate_other.count > 1 ? duplicate_other.first.destroy : ''

      if !material.blank?
        building_wall.update(material_quantity: building_wall.materials.count)
        redirect_to new_survey_building_wall_percentage_path(building_wall_id: building_wall)
      end
    end

    private

      def material_params
        params.permit({ materials: [] }, :details).merge(building_wall: building_wall)
      end

      def survey
        Survey.find params[:survey_id]
      end

      def building_wall
        BuildingWall.find params[:building_wall_id]
      end

      def materials
        [
          "Glass", "High pressure laminate",
          "Aluminium composite material", "Other metal composite material",
          "Metal sheet panels", "Render system",
          "Brick slips", "Brick", "Stone panels or stone",
          "Tilling systems", "Timber or wood",
          "Plastic", "Other"
        ]
      end
  end
end
