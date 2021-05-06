module Admin
  class DeltaController < AdminController
    def update
      Building.mark_on_delta!(building_ids)

      redirect_to admin_root_path, notice: "Building records successfully updated"
    end

    private

    def building_ids
      Array(params[:ids]).map { |id| Integer(id) }
    rescue ArgumentError
      raise ActionController::BadRequest, "Invalid building id: #{params[:id]}"
    end
  end
end
