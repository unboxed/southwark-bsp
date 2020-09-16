require "csv"

class BuildingRecordList
  attr_reader :data

  def self.build_from_uploaded_file(file)
    new(data: file)
  end

  def initialize(data:)
    @data = data
  end

  def building_data
    filtered_csv_data.inject([]) do |result, row|
      attr_ash = row.slice(*header_to_attribute_map.values)
      result << attr_ash
      result
    end
  end

  private

    def filtered_csv_data
      parsed_data.map { |row| row.delete_if { |header, _| header.nil? } }.
        flat_map(&:to_h).uniq! { |row| row[:uprn] }
    end

    def parsed_data
      CSV.parse(File.read(data), headers: true, header_converters: -> (header) { header_to_attribute_map[header] })
    end

    def header_to_attribute_map
      {
        "pao" => :building_name,
        "postcode" => :postcode,
        "street" => :street,
        "town" => :city_town,
        "uprn" => :uprn,
        "LR_title_no" => :land_registry_title_number,
        "LR_ccod_proprietor_name_1" => :land_registry_proprietor_name,
        "LR_ccod_proprietor_1_address_1" => :land_registry_proprietor_address,
        "LR_ccod_proprietorship_category_1" => :land_registry_proprietor_category,
        "LR_ccod_company_registration_no_1" => :land_registry_proprietor_company_registration_number
      }
    end
end
