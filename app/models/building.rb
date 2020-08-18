class Building < ApplicationRecord
  belongs_to :manager, class_name: "BuildingManager"
  has_one :survey
end
