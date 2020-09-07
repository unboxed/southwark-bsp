class BuildingWall < ApplicationRecord
  belongs_to :survey
  has_many :materials, dependent: :destroy
  has_one :section, as: :content
  accepts_nested_attributes_for :materials

  def name
    "Building wall"
  end

  def reply
    self.materials.map do |m|
      "#{m.name}, #{m.percentage}%, insulation: #{m.insulation_material}"
    end.join(", ")
  end

  def should_terminate_survey?
    false
  end
end
