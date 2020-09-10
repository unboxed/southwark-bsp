module Surveys
  class BuildingWallsController < ApplicationController
    include SurveyRoutable

    def index
      @survey = survey
      @previous_section = section(@survey, "BuildingHeight")
    end

    def create
      building_wall = survey.sections.build content: BuildingWall.new
      section = section(survey, "BuildingWall")
      next_section = section(survey, "BuildingWallMaterials")
      redirect_to next_survey_section(current_section: section, survey: survey, next_section: next_section)
    end

    def update
      if building_wall.save
        if session[:previous_url] == survey_summary_url(survey)
          redirect_to survey_summary_path(survey)
        else
          section = section(survey, "BuildingWall")
          next_section = section(survey, "Materials")
          redirect_to next_survey_section(current_section: section, survey: survey, next_section: next_section)
        end
      end
    end

    private

      def survey
        Survey.find params[:survey_id]
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
