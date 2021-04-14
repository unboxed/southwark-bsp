module Survey
  module Sections
    class MaterialDetailsForm < BaseForm
      INSULATION_MATERIALS = %w[
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

      attribute :material_description, :string
      validates :material_description, length: { maximum: 100 }

      attribute :insulation, :string
      validates :insulation, inclusion: { in: INSULATION_MATERIALS }

      attribute :insulation_details, :string

      def insulation_options
        INSULATION_MATERIALS
      end
    end
  end
end
