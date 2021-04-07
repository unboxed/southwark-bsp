module Survey
  module Staging
    extend ActiveSupport::Concern

    STAGES = %w[
      uprn
      ownership
      has_residential
      residential_use
      building_management
      height
      external_walls_summary
      add_material
      material_details
      external_wall_structures
      balcony_materials
      solar_shading_materials
      check_your_answers
      complete
    ]

    included do
      delegate :stage, to: :record

      before_save unless: :last_stage? do
        record.stage = next_logical_stage
      end
    end

    def all_stages
      STAGES
    end

    def goto(stage)
      if stage.in?(STAGES)
        record.update(stage: stage)
      else
        raise SectionNotFound, "Couldn't find stage '#{stage}'"
      end
    end

    def first_stage?
      stage == first_stage
    end

    def last_stage?
      stage == last_stage
    end

    def stage_index
      STAGES.index(stage)
    end

    def first_stage
      STAGES.first
    end

    def previous_stage
      STAGES[[stage_index - 1, 0].max]
    end

    def next_stage
      STAGES[[stage_index + 1, STAGES.size - 1].min]
    end

    def before_stage?(other_stage)
      stage_index < STAGES.index(other_stage)
    end

    def next_logical_stage
      if before_stage?("check_your_answers") && record.completed
        "check_your_answers"
      else
        next_stage
      end
    end

    def last_stage
      STAGES.last
    end
  end
end
