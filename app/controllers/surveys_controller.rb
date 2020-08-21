class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @building = Building.last
    @survey = Survey.create building: @building
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
    @building = Building.includes(:manager).find(params[:building_id])
    @survey = Survey.new building: @building
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.new(survey_params)

    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_params
      params.fetch(:survey, {})
    end
end
