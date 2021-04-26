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
      if params[:commit] == "Mark as 'on Delta'"
        if Building.update_building_collection(params[:building][:building_id].map(&:to_i))
          flash[:notice] = "Building records were updated successfully"
        else
          flash[:error] = "Building records were not updated"
        end
        redirect_to admin_root_path
      else
        redirect_to bulk_notifications_form_admin_buildings_path(request.parameters)
      end
    end

    def bulk_notifications_form
      @buildings = params[:building][:building_id] if params[:building]
      @notification_type = "letter" # we might reintroduce email in the future but for now it's just letters

      render "admin/notifications/notifications_form"
    end

    def confirm_bulk_notifications
      if params[:commit].start_with? "No"
        redirect_to admin_root_path, notice: "No letters were sent."
      else
        Building.send_bulk_notifications(params[:buildings], params[:notification_type])

        redirect_to admin_root_path, notice: "Letter requests sent."
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
