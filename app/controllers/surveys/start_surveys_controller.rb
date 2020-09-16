module Surveys
  class StartSurveysController < ApplicationController
    def index
      @building = building
      @survey = Survey.create building: @building
    end

    def new
      @survey = @survey
      @building = building
    end

    private

      def building
        Building.find params[:for]
      end
  end
end
