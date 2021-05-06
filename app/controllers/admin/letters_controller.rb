module Admin
  class LettersController < AdminController
    before_action :find_buildings, only: %i[confirm]

    def confirm
      respond_to do |format|
        format.html
      end
    end

    def create
      SendLettersJob.perform_later(building_ids)

      redirect_to admin_root_path, notice: "Letter requests sent."
    end

    private

    def building_ids
      Array(params[:ids]).map { |id| Integer(id) }
    rescue ArgumentError
      raise ActionController::BadRequest, "Invalid building id: #{params[:id]}"
    end

    def find_buildings
      @buildings = Building.find(building_ids)
    end
  end
end
