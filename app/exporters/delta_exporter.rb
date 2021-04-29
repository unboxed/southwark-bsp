# rubocop:disable all
require "csv"

class DeltaExporter
  attr_reader :relation

  ADDRESS_FIELDS = %w[
    name
    street
    locality
    city
    postcode
  ]

  BUILDING_FIELDS = %w[
    building-status
    status-details
    UPRN
    tenure
    local-authority
    freeholder
    developer
    agent
    over18
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
    BUILDING_FIELDS +
    MATERIAL_FIELDS +
    STRUCTURE_FIELDS
  ).freeze

  class << self
    def render(relation = Building.export)
      new(relation).render
    end
  end

  def initialize(relation)
    @relation = relation
  end

  def render
    Enumerator.new do |stream|
      stream << header_row

      relation.find_each do |building|
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
      building.csv_for(field)
    end
  end
end
