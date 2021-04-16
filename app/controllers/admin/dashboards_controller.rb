module Admin
  class DashboardsController < AdminController
    before_action :fetch_buildings

    def show; end

    private

    def fetch_buildings
      @buildings = Building.search(search_params)
    end

    def search_params
      params.permit(:state)
    end
  end
end
