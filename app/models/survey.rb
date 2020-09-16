class Survey < ApplicationRecord
  belongs_to :building
  has_many :sections
end
