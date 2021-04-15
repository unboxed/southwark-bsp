require "securerandom"

module Survey
  class Material
    include ActiveModel::Model
    include ActiveModel::Attributes

    MATERIALS = %w[
      glass
      high_pressure_laminate
      aluminium_composite_material
      other_metal_composite_material
      metal_sheet_panels
      render_system
      brick_slips
      brick
      stone_panels_or_stone
      tiling_systems
      timber_or_wood
      plastic
      other
      unknown
    ].freeze

    INSULATION = %w[
      mineral_wool
      pur_or_pir
      phenolic_foam_insulation
      eps_xps
      glass_wool
      wood_fibre
      none
      unknown
      other
    ].freeze

    attribute :id, :string
    attribute :type, :enum, values: MATERIALS
    attribute :other_type, :string
    attribute :details, :string
    attribute :coverage, :integer
    attribute :insulation, :enum, values: INSULATION
    attribute :other_insulation, :string
    attribute :insulation_details, :string

    define_model_callbacks :initialize, :save
    after_initialize :generate_id

    before_save unless: :other? do
      self.other_type = nil
    end

    def initialize(attributes = {})
      run_callbacks :initialize do
        super
      end
    end

    def eql?(other)
      id == other.id
    end

    def other?
      type == "other"
    end

    def other_insulation?
      insulation == "other"
    end

    def as_json(*)
      attributes.as_json
    end

    private

    def generate_id
      self.id ||= SecureRandom.uuid.split("-").first
    end
  end
end
