module DashboardHelper
  def filtered?
    @buildings.scope != :all || @buildings.filters.present? # rubocop:disable Rails/HelperInstanceVariable
  end

  def selected_facet
    params[:state].presence || "all"
  end

  def selected_delta_facet
    params[:delta_state].presence || "all"
  end
end
