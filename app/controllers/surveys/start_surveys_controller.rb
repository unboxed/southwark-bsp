module Surveys
  class StartSurveysController < ApplicationController
    def new
      render locals: {
        survey: survey,
        building: building
      }
    end

    private

      def building
        Building.includes(:manager).find params[:for]
      end

      def survey
        Survey.create building: building
      end
  end
end
