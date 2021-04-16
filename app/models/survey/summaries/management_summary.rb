module Survey
  module Summaries
    class ManagementSummary < BaseSummary
      self.attribute_names = %i[
        right_to_manage_company building_owner
        building_developer managing_agent
      ]

      delegate *attribute_names, to: :record
      delegate :is_right_to_manage, to: :record

      def value_for_right_to_manage_company
        lookup(is_right_to_manage, :is_right_to_manage, company: right_to_manage_company)
      end

      def value_for_building_owner
        building_owner.presence || "–"
      end

      def value_for_building_developer
        building_developer.presence || "–"
      end

      def value_for_managing_agent
        managing_agent.presence || "–"
      end

      def url_for_right_to_manage_company
        goto_path("building_management")
      end

      def url_for_building_owner
        goto_path("building_management")
      end

      def url_for_building_developer
        goto_path("building_management")
      end

      def url_for_managing_agent
        goto_path("building_management")
      end
    end
  end
end
