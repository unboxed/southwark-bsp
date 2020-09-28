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
      "#{m.name} #{m.details ? m.details : '-'} #{m.percentage ? m.percentage.material_percentage : '-'}%, insulation: #{m.insulation ? m.insulation.insulation_material : '-'}"
    end.join("\n")
  end

  def should_terminate_survey?
    false
  end
end
