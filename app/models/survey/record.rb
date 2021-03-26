module Survey
  class Record < ApplicationRecord
    belongs_to :building

    # stage: uprn
    store_accessor :data, :uprn

    # stage: ownership
    store_accessor :data, :role, :right_to_manage_company
    store_accessor :data, :full_name, :email, :organisation
    store_accessor :data, :ownership_details

    # stage: status
    store_accessor :data, :status, :status_details
  end
end
