module Admin
  class DashboardsController < AdminController
    before_action :fetch_buildings

    def show
    end

    private

    def fetch_buildings
      scope = Building.left_outer_joins(:surveys)

      if params[:completed] == "1"
        scope = scope.where.not('surveys.completed_at' => nil)
      end

      if params[:not_received] == "1"
        scope = scope.where('surveys.completed_at' => nil)
      end

      @buildings = scope
    end
  end
end
