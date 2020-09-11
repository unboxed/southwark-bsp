module Surveys
  class BuildingWallMaterialPercentagesController < ApplicationController
    include SurveyRoutable

  def new
    @survey = survey
    @building_wall_material_percentage = BuildingWallMaterialPercentage.new
    @building_wall_materials = building_wall_materials
  end

  def create
    percentage =  BuildingWallMaterialPercentage.new(building_wall_material_percentage_params)
    if percentage.save
      redirect_to new_survey_building_wall_building_wall_material_insulation_path(survey, building_wall_id: building_wall)
    end
  end

  def edit
  end

  def update
  end

  private

    def building_wall
      BuildingWall.find params[:building_wall_id]
    end

    def building_wall_materials
      building_wall.building_wall_materials
    end

    def survey
      Survey.find params[:survey_id]
    end
  end
end
