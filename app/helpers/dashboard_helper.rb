module DashboardHelper
  def filtered?
    @buildings.scope != :all # rubocop:disable Rails/HelperInstanceVariable
  end

  def selected_delta_facet
    params[:delta_state].presence || "all"
  end
end
