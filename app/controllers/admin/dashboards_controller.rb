module Admin
  class DashboardsController < AdminController
    before_action :fetch_buildings

    def show; end

    private

    def fetch_buildings
      scope = Building.left_outer_joins(:surveys)

      scope = scope.where.not('surveys.completed_at' => nil) if params[:completed] == "1"

      scope = scope.where('surveys.completed_at' => nil) if params[:not_received] == "1"

      @buildings = scope
    end
  end
end
