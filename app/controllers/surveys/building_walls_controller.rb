module Surveys
  class BuildingWallsController < ApplicationController
    include SurveyRoutable

    def index
      @survey = survey
      @section = section(@survey, "BuildingHeight")
    end

    def new
      @survey = survey
      @section = section(@survey, "BuildingHeight")
      @building_wall = BuildingWall.new(survey: @survey)
      @options_for_materials = materials
    end

    def create
      building_wall = survey.sections.build content: BuildingWall.new(building_walls_params)

      if building_wall.save
        filtered_materials.map { |material|
          if material == "Other"
            Material.create(building_wall_id: building_wall.content.id, name: material, details: params[:building_wall][:details])
          else
            Material.create(building_wall_id: building_wall.content.id, name: material)
          end
        }
        redirect_to new_survey_building_wall_material_path(survey_id: survey.id, building_wall_id: building_wall.content.id)
      end
    end

    def edit
      session[:previous_url] = request.referer
      @survey = survey
      @section = section(@survey, "BuildingHeight")
      @building_wall = building_wall
      @options_for_materials = materials
      @other_material = building_wall.materials.where(name: "Other").map { | material | material.details }
    end

    def update
      building_materials = filtered_materials.each { |material|
        if material == "Other"
          Material.find_or_create_by(building_wall_id: building_wall.id, name: material, details: params[:building_wall][:details])
        else
          Material.find_or_create_by(building_wall_id: building_wall.id, name: material)
        end
      }
      building_wall.materials.each { |obj| obj.destroy unless building_materials.include?(obj.name) }
      duplicate_other = building_wall.materials.where(name: "Other")
      duplicate_other.count > 1 ? duplicate_other.first.destroy : ''

      if building_wall.save
        next_section = section(survey, "Materials")
        redirect_to next_survey_section(current_section: building_wall.section, survey: survey, next_section: next_section)
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
      end

      def building_walls_params
        params.require(:building_wall).permit(:material_quantity, { materials: [:name, :details, :percentage, :insulation_material, :insulation_details] }).merge(survey: survey)
      end

      def building_wall
        BuildingWall.find params[:id]
      end

      def filtered_materials
        params[:building_wall][:materials].reject { |n| n.blank? }
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
