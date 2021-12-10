module Admin
  class SearchesController < AdminController
    def show
      @search_term = params[:q]
      @buildings = Building.search(params)
    end
  end
end
