module AdminHelper
  def filtered?
    @buildings.scope != :all || @buildings.filters.present? # rubocop:disable Rails/HelperInstanceVariable
  end

  def selected_facet
    params[:state].presence || "all"
  end

  def selected_delta_facet
    params[:delta_state].presence || "all"
  end

  def summary_row(key, value)
    label = t(key, scope: "admin.buildings.show.labels")
    content_tag(:div, class: "govuk-summary-list__row") do
      concat(content_tag(:dt, label, class: "govuk-summary-list__key"))
      concat(content_tag(:dd, value, class: "govuk-summary-list__value"))
    end
  end
end
