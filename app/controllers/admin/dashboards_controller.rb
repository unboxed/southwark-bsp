module Admin
  class DashboardsController < AdminController
    before_action :fetch_buildings, :fetch_total

    def show; end

    private

    def fetch_buildings
      @buildings = Building.search(params)
    end

    def fetch_total
      @total = Building.all.count
    end
  end
end
