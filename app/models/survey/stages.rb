module Survey
  module Stages
    extend ActiveSupport::Concern

    included do
      stage "uprn", initial: true
      stage "ownership"
      stage "has_residential"
      stage "residential_use"
      stage "building_management"
      stage "height"
      stage "external_walls_summary"
      stage "external_wall_structures"
      stage "balcony_materials"
      stage "solar_shading_materials"
      stage "check_your_answers"
      stage "complete"

      transition from: "uprn",
        to: %w[
          ownership
          check_your_answers
        ]

      transition from: "ownership",
        to: %w[
          has_residential
          uprn
          check_your_answers
        ]

      transition from: "has_residential",
        to: %w[
          residential_use
          ownership
          check_your_answers
        ]

      transition from: "residential_use",
        to: %w[
          building_management
          has_residential
          check_your_answers
        ]

      transition from: "building_management",
        to: %w[
          height
          residential_use
          check_your_answers
        ]

      transition from: "height",
        to: %w[
          external_walls_summary
          building_management
          check_your_answers
        ]

      transition from: "external_walls_summary",
        to: %w[
          external_wall_structures
          height
          check_your_answers
        ]

      transition from: "external_wall_structures",
        to: %w[
          balcony_materials
          solar_shading_materials
          external_walls_summary
          check_your_answers
        ]

      transition from: "balcony_materials",
        to: %w[
          solar_shading_materials
          external_wall_structures
          check_your_answers
        ]

      transition from: "solar_shading_materials",
        to: %w[
          check_your_answers
          balcony_materials
          external_wall_structures
        ]

      transition from: "check_your_answers", to: stages

      guard to: "check_your_answers" do
        completed
      end

      guard to: stages - %w[uprn] do
        building.present?
      end
    end
  end
end
