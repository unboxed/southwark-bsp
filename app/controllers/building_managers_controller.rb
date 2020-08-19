class BuildingManagersController < ApplicationController
  def index
    @building_managers = BuildingManager.all
  end

  private
    def building_manager_params
      params.require(:building_manager).permit(:email)
    end
end
