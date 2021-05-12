module Survey
  class Record < ApplicationRecord
    include Survey::Staging
    include Survey::Stages
    include Survey::Summaries

    belongs_to :building, optional: true

    scope :completed, -> { where.not(completed_at: nil) }
    scope :latest_completed, -> { completed.order(completed_at: :desc) }

    # stage: uprn
    store_accessor :data, :uprn

    # stage: ownership
    store_accessor :data, :role, :role_details
    store_accessor :data, :full_name, :email, :organisation

    # stage: has residential
    store_accessor :data, :has_residential_use # FIXME: this should be indicated by the next stage

    # stage: residential use
    store_accessor :data, :usage

    # stage: management
    store_accessor :data,
                   :is_right_to_manage,
                   :right_to_manage_company,
                   :building_owner,
                   :building_developer,
                   :managing_agent

    # stage: height
    store_accessor :data, :height_in_metres, :number_of_storeys

    # stage: external walls summary
    store_accessor :data, :materials

    # stage: add material, edit material, delete material
    store_accessor :data, :material

    # stage: external wall structures
    store_accessor :data, :structures, :structures_details

    # stage: balconies
    store_accessor :data,
                   :balcony_main_material,
                   :balcony_main_material_details,
                   :balcony_floor_materials,
                   :balcony_floor_materials_details,
                   :balcony_railing_materials,
                   :balcony_railing_materials_details

    # stage: solar shading materials
    store_accessor :data,
                   :solar_shading_materials,
                   :solar_shading_materials_details

    # stage: check your answers
    store_accessor :data,
                   :completed

    def form_attributes
      @form_attributes ||= self.class.stored_attributes[:data].map(&:to_s)
    end

    def completed=(value)
      super(value)

      building.survey_state.transition_to! :received if value == true
    end
  end
end
