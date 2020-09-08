class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    if params.has_key?(:uprn)
      @building = Building.find_by(uprn: params[:uprn])
      @survey = Survey.create building: @building
    end
  end

  def new
    @building = Building.new
    @survey = Survey.new building: @building
  end

  def create
    @building = Building.find_by(uprn: params[:survey][:uprn])
    @survey = Survey.new building: @building
    if @survey.save
      redirect_to new_survey_building_status_path(@survey)
    else
      respond_to do |format|
        format.html { render :new  }
      end
    end
  end
end
