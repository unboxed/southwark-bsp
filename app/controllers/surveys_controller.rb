class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @building = Building.last
    @survey = Survey.create building: @building
  end
end
