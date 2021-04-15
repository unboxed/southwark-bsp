module Admin
  class DashboardsController < AdminController
    before_action :fetch_buildings, :filtered?, :fetch_total

    def show; end

    private

    def fetch_buildings
      scope = Building.left_outer_joins(:surveys)

      scope = scope.where.not('survey_records.completed_at' => nil) if params[:completed] == "1"

      scope = scope.where('survey_records.completed_at' => nil) if params[:not_received] == "1"

      @buildings = scope
    end

    def fetch_total
      @total = Building.count
    end

    def filtered?
      @filtered = !!(params[:completed] || params[:not_received])
    end
  end
end
