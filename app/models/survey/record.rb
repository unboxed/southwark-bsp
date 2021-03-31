module Survey
  class Record < ApplicationRecord
    belongs_to :building

    # stage: uprn
    store_accessor :data, :uprn

    # stage: ownership
    store_accessor :data, :role
    store_accessor :data, :full_name, :email, :organisation
    store_accessor :data, :ownership_details

    # stage: has residential
    store_accessor :data, :has_residential_usage # FIXME: this should be indicated by the next stage

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
  end
end
