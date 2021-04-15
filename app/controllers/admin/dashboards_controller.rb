module Admin
  class DashboardsController < AdminController
    before_action :fetch_buildings, :filtered?, :fetch_total

    def show; end

    private

    def fetch_buildings
      @buildings = Building.search(params)
    end

    def fetch_total
      @total = Building.all.count
    end

    def filtered?
      @filtered = params[:state]
    end
  end
end
