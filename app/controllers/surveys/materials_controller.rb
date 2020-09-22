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
      @error = nil
      @survey = survey
      @previous_section = section(@survey, "BuildingHeight")
      @options_for_materials = materials
      @building_wall = building_wall
      all_materials = material_params[:materials]

      if all_materials == nil
        @error = "Please choose one of the options provided and leave a comment"
        render :new
        return
      end

      materials_created = all_materials.map do |material|
        if material == "Other"
          Material.create(name: "Other", details: material_params[:details], building_wall_id: building_wall.id, comments: material_params[:comments])
        else
          Material.create(name: material, building_wall_id: building_wall.id, comments: material_params[:comments])
        end
      end
      if materials_created.any? { |m| !m.errors.empty? }
        @error = "Please choose one of the options provided and leave a comment"
        render :new
        return
      end

      if !all_materials.blank?
        building_wall.update(material_quantity: building_wall.materials.count)
        building_wall.materials.map { |m| m.percentage ? m.percentage.destroy : '' }
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
      @error = nil
      @survey = survey
      @previous_section = section(@survey, "BuildingHeight")
      @options_for_materials = materials
      @building_wall = building_wall
      @other_material = building_wall.materials.where(name: "Other").pluck(:details)

      all_materials = material_params[:materials]
      if all_materials == nil
        @error = "Please choose one of the options provided and leave a comment"
        render :edit
        return
      end
      obj_to_delete = building_wall.materials.select { |m| all_materials.include?(m.name) == false }
      obj_to_update = building_wall.materials.select { |m| all_materials.include?(m.name) }
      obj_to_create = all_materials.select { |n| building_wall.materials.find { |m| m.name == n } == nil }

      obj_to_delete.each do |m|
        m.try(:destroy)
      end

      obj_to_update.each do |material|
          if material.name == "Other"
            material.update_attributes(comments: params[:comments], details: params[:details])
          else
            material.update_attribute(:comments, params[:comments])
          end
        end

      created_materials = obj_to_create.map do |material|
          if material == "Other"
            Material.create(name: material, building_wall_id: building_wall.id, comments: params[:comments], details: params[:details])
          else
            Material.create(name: material, building_wall_id: building_wall.id, comments: params[:comments])
          end
        end

      if obj_to_update.any? { |m| !m.valid? } || created_materials.any? { |m| !m.errors.empty? }
        @error = "Please choose one of the options provided and leave a comment"
        render :edit
        return
      end

      if !all_materials.blank?
        building_wall.update(material_quantity: building_wall.materials.count)
        redirect_to new_survey_building_wall_percentage_path(building_wall_id: building_wall)
      end
    end

    private

      def material_params
        params.permit({ materials: [] }, :details, :comments).merge(building_wall: building_wall)
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
