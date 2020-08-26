class BuildingManager < ApplicationRecord
  has_many :buildings, foreign_key: :manager_id
end
