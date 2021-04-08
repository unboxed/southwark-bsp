module Admin
  class BuildingsController < AdminController
    def new
      @building = Building.new
    end

    def create
      @building = Building.new building_params

      if @building.save
        redirect_to admin_root_path
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
        redirect_to admin_root_path
      else
        render :edit
      end
    end

    def bulk_update
      if params[:building] && Building.find(params[:building][:building_id].map(&:to_i))
                                      .each { |element| apply_update(element) }
        flash[:notice] = "Building records were updated successfully"
      else
        flash[:error] = "Building records were not updated"
      end
      redirect_to admin_root_path
    end

    def apply_update(building)
      if params[:commit] == "Mark as 'on Delta'"
        building.update!(on_delta: 1)
      else
        redirect_to admin_root_path
      end
    end

    private

    def building_params
      params.require(:building).permit(
        :uprn,
        :building_name,
        :building_id,
        :street,
        :postcode,
        :land_registry_proprietor_address,
        :land_registry_proprietor_name,
        :proprietor_email,
        :on_delta,
        :letter,
        :email
      )
    end

    def building
      Building.find params[:id]
    end
  end
end
