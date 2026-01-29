module Admin
  class SearchesController < AdminController
    before_action :find_buildings, :set_current_search

    def show
      respond_to do |format|
        format.html
      end
    end

    private

    def find_buildings
      @buildings = Building.search(params)
    end

    def set_current_search
      session["current_search"] = @buildings.current_params
    end
  end
end
