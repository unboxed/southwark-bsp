module Admin
  class SearchesController < AdminController
    def show
      @buildings = Building.search(params)
    end
  end
end
