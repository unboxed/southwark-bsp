class Percentage < ApplicationRecord
  belongs_to :material, foreign_key: :material_id, class_name: 'Material'
end
