module Admin
  class BuildingsController < AdminController
    def new
      @building = Building.new
    end

    def create
      @building = Building.new building_params

      if @building.save
        redirect_to admin_dashboard_path
      else
        render :new
      end
    end

    def edit
      @building = building
    end

    def update
      @building = building

      if @building.update building_params
        redirect_to admin_dashboard_path
      else
        render :edit
      end
    end

    private

      def building_params
        params.require(:building).permit(
          :uprn,
          :building_name,
          :street,
          :postcode,
          :land_registry_proprietor_address,
          :land_registry_proprietor_name,
          :proprietor_email,
        )
      end

      def building
        Building.find params[:id]
      end
  end
end
