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

  def self.generate_materials
    attrs = (1..10).flat_map do |index|
      prefix = "material-#{index}"
      material_prop = proc { |building, prop| building&.survey&.materials[index]&.fetch(prop) }

      [
        ["material-#{index}", -> { material_prop.call self, "type" }],
        ["material-details-#{index}", -> { material_prop.call self, "details" }],
        ["coverage-#{index}", -> { material_prop.call self, "coverage" }],
        ["insulation-#{index}", -> { material_prop.call self, "insulation" }],
        ["insulation-details-#{index}", -> { material_prop.call self, "insulation_details" }]
      ]
    end

    attrs.to_h
  end

  VALUES = {
    "name" => -> { building_name.presence || street.to_s.split("\n").first.presence },
    "street" => -> { street.to_s.split("\n").first.presence },
    "locality" => -> { street.to_s.split("\n").second.presence },
    "city" => -> { city_town },
    "postcode" => -> { postcode },
    "UPRN" => -> { uprn },
    "building-status" => -> { "existing" },
    "status-details" => -> { nil },
    "tenure" => -> { nil },
    "local-authority" => -> { "Southwark" },
    "freeholder" => -> { survey.building_owner },
    "developer" => -> { survey.building_developer },
    "agent" => -> { survey.managing_agent },
    "over18" => -> { "yes" },
    "height-storeys" => -> { survey ? survey.number_of_storeys : nil },
    "height-metres" => -> { survey ? survey.height_in_metres : nil },
    "number-of-materials" => -> { survey ? survey.materials.size : nil },
    **generate_materials
  }

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
      VALUES.key?(field) ? building.instance_exec(&VALUES[field]) : nil
    end
  end
end
