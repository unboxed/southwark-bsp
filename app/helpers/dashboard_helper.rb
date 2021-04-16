module DashboardHelper
  def selected_facet
    params[:state].presence || "all"
  end

  def filtered?
    selected_facet != "all"
  end
end
