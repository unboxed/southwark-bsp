# rubocop:disable Metrics/ModuleLength, Metrics/BlockLength

module BuildingCsvMapper
  extend ActiveSupport::Concern

  COVERAGE_RANGES = [(0..20), (21..40), (41..60), (61..80), (81..100)].freeze

  included do
    def building_csv_for(field)
      mapping = "csv_#{field.underscore}".to_sym
      send mapping if respond_to? mapping
    end

    def with_survey
      return nil if survey&.completed_at.blank?

      yield survey
    end

    def with_survey_material(index)
      with_survey do |survey|
        materials = Array(survey.materials)
        yield materials[index] if materials[index].present?
      end
    end

    def csv_current_state
      survey_state&.current_state&.humanize
    end

    def csv_height_storeys
      with_survey(&:number_of_storeys)
    end

    def csv_height_metres
      with_survey { |s| s.height_in_metres.to_i }
    end

    def csv_number_of_materials
      with_survey { |s| Array(s.materials).size }
    end

    (1..16).each do |index|
      define_method "csv_notification_mean_#{index}" do
        notification = notifications[index - 1]
        return if notification.blank?

        notification[:notification_mean]
      end

      define_method "csv_sent_at_#{index}" do
        notification = notifications[index - 1]
        return if notification.blank?

        notification[:sent_at]
      end
    end

    (1..10).each do |index|
      define_method "csv_material_#{index}" do
        with_survey_material(index - 1) do |material|
          value = material["type"] == "other" ? material["other_type"] : material["type"]

          with_unknown_as(value, "donotknow")
        end
      end

      define_method "csv_material_details_#{index}" do
        with_survey_material(index - 1) { |m| m['details'] }
      end

      define_method "csv_coverage_#{index}" do
        coverage = with_survey_material(index - 1) { |m| m['coverage'] }

        coverage && COVERAGE_RANGES.find { |r| r.include? coverage }.to_s.gsub("..", "-")
      end

      define_method "csv_insulation_#{index}" do
        with_survey_material(index - 1) do |material|
          value = material["insulation"] == "other" ? material["other_insulation"] : material["insulation"]

          with_unknown_as(value, "do not know")
        end
      end

      define_method "csv_insulation_details_#{index}" do
        with_survey_material(index - 1) { |m| m['insulation_details'] }
      end
    end

    def csv_wall_attachments
      with_survey { |s| Array(s.structures).join(" ") }
    end

    def csv_usage
      with_survey do |survey|
        survey&.usage&.humanize&.downcase
      end
    end

    def csv_building_owner
      with_survey(&:building_owner)
    end

    def csv_building_developer
      with_survey(&:building_developer)
    end

    def csv_managing_agent
      with_survey(&:managing_agent)
    end

    def csv_wall_attachments_other
      with_survey(&:structures_details)
    end

    def csv_balconies_material_structure
      with_survey { |s| with_unknown_as(s.balcony_main_material, "do-not-know") }
    end

    def csv_balconies_material_floor
      with_survey do |s|
        s.balcony_floor_materials&.map { |m| with_unknown_as(m, "do-not-know") }&.join(" ")
      end
    end

    def csv_balconies_material_floor_other
      with_survey(&:balcony_floor_materials_details)
    end

    def csv_balconies_material_balustrade
      with_survey do |s|
        s.balcony_railing_materials&.map { |m| with_unknown_as(m, "do-not-know") }&.join(" ")
      end
    end

    def csv_balconies_material_balustrade_other
      with_survey(&:balcony_railing_materials_details)
    end

    def csv_solarshading_materials
      with_survey do |s|
        s.solar_shading_materials&.map { |m| with_unknown_as(m, "do-not-know") }&.join(" ")
      end
    end

    def csv_solarshading_materials_other
      with_survey(&:solar_shading_materials_details)
    end

    def csv_date_of_latest_state_change
      survey_state&.last_transition&.created_at&.strftime("%d %B %Y")
    end

    private

    def with_unknown_as(value, replacement)
      if value == "unknown"
        replacement
      else
        value
      end
    end
  end
end

# rubocop:enable Metrics/ModuleLength, Metrics/BlockLength
