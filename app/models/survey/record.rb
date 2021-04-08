module Survey
  class Record < ApplicationRecord
    belongs_to :building

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

    # stage: add material
    store_accessor :data, :material, :material_details

    # stage: add material details
    store_accessor :data, :material_description, :insulation, :insulation_details

    # stage: external wall structures
    store_accessor :data, :structures, :structures_details

    # stage: balconies
    store_accessor :data,
                   :balcony_main_material,
                   :balcony_main_material_details,
                   :balcony_floor_materials,
                   :balcony_floor_materials_details,
                   :balcony_other_materials,
                   :balcony_other_materials_details

    # stage: solar shading materials
    store_accessor :data,
                   :solar_shading_materials,
                   :solar_shading_materials_details

    # stage: check your answers
    store_accessor :data,
                   :completed
  end
end
