module Surveys
  class SummariesController < ApplicationController
    def show
      @survey = survey
    end

    private

      def survey
        Survey.find params[:survey_id]
      end
  end
end
