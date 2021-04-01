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
  end
end
