module Survey
  module Summaries
    class BuildingSummary < BaseSummary
      self.attribute_names = %i[
        uprn address residential_use
        height_in_metres number_of_storeys
      ]

      delegate :uprn, :has_residential_use, :usage, to: :record
      delegate :height_in_metres, :number_of_storeys, to: :record
      delegate :address, to: :building

      def initialize(...)
        super

        unless has_residential_use
          self.attribute_names = %i[uprn address residential_use]
        end
      end

      def value_for_uprn
        uprn
      end

      def value_for_address
        simple_format(address, class: "govuk-body")
      end

      def value_for_residential_use
        lookup((has_residential_use ? usage : "none"), :residential_use)
      end

      def value_for_height_in_metres
        if height_in_metres.blank?
          "–"
        else
          number_with_precision(height_in_metres, precision: 1) + "m"
        end
      end

      def value_for_number_of_storeys
        if number_of_storeys.blank?
          "–"
        else
          number_with_precision(number_of_storeys, precision: 0)
        end
      end

      def url_for_uprn
        goto_path("uprn")
      end

      def url_for_address
        false
      end

      def url_for_residential_use
        if has_residential_use
          goto_path("residential_use")
        else
          goto_path("has_residential")
        end
      end

      def url_for_height_in_metres
        goto_path("height")
      end

      def url_for_number_of_storeys
        goto_path("height")
      end
    end
  end
end
