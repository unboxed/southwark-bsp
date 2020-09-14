class Material < ApplicationRecord
  belongs_to :building_wall
  has_one :insulation, dependent: :destroy
  has_one :percentage, dependent: :destroy

  validates :name, presence: true, allow_blank: false

  def should_terminate_survey?
    false
  end
end
