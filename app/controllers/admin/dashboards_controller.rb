module Admin
  class DashboardsController < AdminController
    def show
      @buildings = Building.all.ordered_by_uprn
    end
  end
end
