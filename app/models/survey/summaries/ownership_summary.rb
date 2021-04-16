module Survey
  module Summaries
    class OwnershipSummary < BaseSummary
      self.attribute_names = %i[full_name email role]

      delegate *attribute_names, to: :record
      delegate :role_details, to: :record

      def value_for_full_name
        full_name
      end

      def value_for_email
        email
      end

      def value_for_role
        lookup(role, :role, other: role_details)
      end

      def url_for_full_name
        goto_path("ownership")
      end

      def url_for_email
        goto_path("ownership")
      end

      def url_for_role
        goto_path("ownership")
      end
    end
  end
end
