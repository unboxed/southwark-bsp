class SurveysController < ApplicationController
  # main page
  def index
    if params.has_key?(:uprn)
      @building = Building.find_by(uprn: params[:uprn])
      if @building.survey != nil
        @survey = @building.survey
        destroy_building_wall= false
        # a=@survey.sections.where(content_type:"BuildingWall")
        # a[0].content.materials.each do |material|
        #   if material.percentage == nil
        #     destroy_building_wall= true
        #     break
        #   end
        # end
        # if destroy_building_wall ==true
        #   a[0].try(:destroy)
        # end
      else
        @survey = Survey.create building: @building
      end
    end
  end

# we get here when we click on submit button on summary page "end_survey"
  def show
    @uprn = survey.building.uprn
  end

  # get started page 
  def new
    @building = Building.new
    @survey = Survey.new building: @building
  end

  def create
    @building = Building.find_by(uprn: params[:survey][:uprn])
    if @building.survey != nil
      redirect_to survey_summary_path(@building.survey)
    else
      @survey = Survey.new building: @building
      if @survey.save
        redirect_to new_survey_building_ownership_path(@survey)
      else
        respond_to do |format|
          format.html { render :new  }
        end
      end
    end
  end


  private

    def survey
      Survey.find params[:survey_id]
    end
end
