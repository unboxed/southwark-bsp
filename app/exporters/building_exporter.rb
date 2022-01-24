# rubocop:disable all
require "csv"

class BuildingExporter
  attr_reader :relation

  ADDRESS_FIELDS = %w[
    current_state
    date_of_latest_state_change
    uprn
    building_name
    street
    city_town
    postcode
    land_registry_title_number
    land_registry_proprietor_name
    land_registry_proprietor_address
    land_registry_proprietor_category
    land_registry_proprietor_company_registration_number
  ]

  NOTIFICATION_FIELDS = (1..16).flat_map do |i|
    %W[
      notification_mean-#{i}
      sent_at-#{i}
    ]
  end

  BUILDING_FIELDS = %w[
    usage
    building_owner
    building_developer
    managing_agent
    height-storeys
    height-metres
    number-of-materials
  ]

  MATERIAL_FIELDS = (1..10).flat_map do |i|
    %W[
      material-#{i}
      material-details-#{i}
      coverage-#{i}
      insulation-#{i}
      insulation-details-#{i}
    ]
  end

  STRUCTURE_FIELDS = %w[
    wall-attachments
    wall-attachments-other
    balconies-material-structure
    balconies-material-floor
    balconies-material-floor-other
    balconies-material-balustrade
    balconies-material-balustrade-other
    balconies-details
    solarshading-materials
    solarshading-materials-other
  ]

  FIELDS = (
    ADDRESS_FIELDS +
    NOTIFICATION_FIELDS +
    BUILDING_FIELDS +
    MATERIAL_FIELDS +
    STRUCTURE_FIELDS
  ).freeze

  class << self
    def render(relation = Building.in_state(:not_contacted) + Building.in_state(:contacted) + Building.in_state(:received) + Building.in_state(:rejected) + Building.in_state(:accepted))
      new(relation).render
    end
  end

  def initialize(relation)
    @relation = relation
  end

  def render
    Enumerator.new do |stream|
      stream << header_row

      relation.each do |building|
        stream << building_row(building)
      end
    end
  end

  private

  def header_row
    CSV::Row.new(FIELDS, FIELDS, true).to_s
  end

  def building_row(building)
    CSV::Row.new(FIELDS, values(building)).to_s
  end

  def values(building)
    FIELDS.map do |field|
      building.respond_to?(field) ? building.send(field) : building.building_csv_for(field)
    end
  end
end
