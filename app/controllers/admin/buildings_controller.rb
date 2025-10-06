module Admin
  class BuildingsController < AdminController
    before_action :build_building, only: %i[new create]
    before_action :find_building, except: :index
    before_action :find_buildings, :set_current_search, only: :index

    def index
      respond_to do |format|
        format.csv do
          set_streaming_headers
          if params[:all_buildings] == "true"
            set_building_file_headers
            self.response_body = BuildingExporter.render
          else
            set_delta_file_headers
            self.response_body = DeltaExporter.render
          end
        end

        format.html
      end
    end

    def new
      respond_to do |format|
        format.html
      end
    end

    def create
      if @building.update(building_params)
        redirect_to admin_root_path, notice: "Building record successfully created"
      else
        respond_to do |format|
          format.html { render :new }
        end
      end
    end

    def edit
      respond_to do |format|
        format.html
      end
    end

    def show
      respond_to do |format|
        format.html
      end
    end

    def update
      if @building.update(building_params)
        redirect_to admin_building_path(@building), notice: "Building record successfully updated"
      else
        respond_to do |format|
          format.html { render :update }
        end
      end
    end

    def destroy
      @building.destroy

      redirect_to admin_root_path, notice: "Building record successfully deleted"
    end

    def survey_state
      if params[:commit] == "Accept survey data"
        @building.survey.accept!
      else
        @building.survey.reject!
      end

      redirect_to admin_building_path(@building), notice: "Survey state has been updated."
    end

    private

    def building_params
      params.expect(building: building_attributes)
    end

    def building_attributes
      %i[
        uprn
        building_name
        street
        city_town
        postcode
        land_registry_proprietor_address
        land_registry_proprietor_name
        proprietor_email
      ]
    end

    def building_uprn
      params[:uprn] || params[:building_uprn]
    end

    def find_building
      @building = Building.find_by(uprn: building_uprn)
    end

    def build_building
      @building = Building.new
    end

    def find_buildings
      @current_state = params[:state] || "not_contacted"
      @total_count = Building.count

      @buildings = Building.search(search_params.merge(state: @current_state))
    end

    def search_params
      params.permit(:state, :page, :q)
    end

    def set_building_file_headers(time = Time.current)
      headers["Content-Type"] = "text/csv"
      headers["Content-Disposition"] = "attachment; filename=buildings-export-#{time.to_fs(:number)}.csv"
    end

    def set_delta_file_headers(time = Time.current)
      headers["Content-Type"] = "text/csv"
      headers["Content-Disposition"] = "attachment; filename=delta-export-#{time.to_fs(:number)}.csv"
    end

    def set_streaming_headers(time = Time.current)
      headers["X-Accel-Buffering"] = "no"
      headers["Cache-Control"] ||= "no-cache"
      headers["Last-Modified"] = time.httpdate
      headers.delete("Content-Length")
    end

    def set_current_search
      session["current_search"] = @buildings.current_params
    end
  end
end
