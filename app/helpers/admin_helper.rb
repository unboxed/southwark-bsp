# rubocop:disable Rails/HelperInstanceVariable

module AdminHelper
  def filtered?
    @buildings.scope != :all || @buildings.filters.present?
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

  def tab_percentage
    number = (1.0 * @buildings.total_entries / @total_count) * 100
    number_to_percentage(number, precision: 0)
  end
end

# rubocop:enable Rails/HelperInstanceVariable
