class Insulation < ApplicationRecord
  belongs_to :material, foreign_key: :material_id, class_name: 'Material'

  validates :insulation_material, presence: { message: "can't be blank. Please select one value from the list" }
  validates :insulation_details, presence:  { message: "can't be blank. Please provide further details in the comment box" }, allow_blank: false
end
