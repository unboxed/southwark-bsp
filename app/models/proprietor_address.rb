class ProprietorAddress
  attr_reader :building, :full_address, :parsed_address_map

  def initialize(building)
    @building = building
    @full_address = building.land_registry_proprietor_address
    @parsed_address_map = {}
  end

  def parsed
    parsed_address
  end

  private

    def normalised_address
      if address_contains_uk_postcode?
        full_address.gsub(uk_postcode_regex) { |match| match.prepend "," }
      else
        full_address
      end
    end

    def parsed_address
      segmented_address.each_with_index do |segment, index|
        parsed_address_map["line_#{index}"] = segment.squish
      end
      parsed_address_map.with_indifferent_access
    end

    def address_contains_uk_postcode?
      full_address.scan(uk_postcode_regex).any?
    end

    def uk_postcode_regex
      /\b(?:[A-Z][A-HJ-Y]?[0-9][0-9A-Z]? ?[0-9][A-Z]{2}|GIR ?0A{2})\b/i
    end

    def segmented_address
      normalised_address.split(",").compact_blank
    end
end
