class StartSurveysController < ApplicationController
  def new
    @building = building
  end

  private

    def building
      Building.find params[:building_id]
    end
end
