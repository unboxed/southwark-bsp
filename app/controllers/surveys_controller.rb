class SurveysController < ApplicationController
  def index
    if params.has_key?(:uprn)
      @building = Building.find_by(uprn: params[:uprn])
      @survey = Survey.create building: @building
    end
  end

  def show
    @reference = survey.reference_id
  end

  def new
    @building = Building.new
    @survey = Survey.new building: @building
  end

  def create
    @building = Building.find_by(uprn: params[:survey][:uprn])
    @survey = Survey.new building: @building
    if @survey.save
      redirect_to new_survey_building_ownership_path(@survey)
    else
      respond_to do |format|
        format.html { render :new  }
      end
    end
  end


  private

    def survey
      Survey.find params[:survey_id]
    end
end
