class BuildingWall < ApplicationRecord
  belongs_to :survey
  has_many :materials, dependent: :destroy
  has_one :section, as: :content
  accepts_nested_attributes_for :materials
  validate :percentage_exactly_100

  def name
    "Building wall"
  end

  def reply
    self.materials.map do |m|
      "#{m.name} #{m.details ? m.details : '-'} #{m.percentage}%, insulation: #{m.insulation_material}"
    end.join("\n")
  end

  def should_terminate_survey?
    false
  end

  def percentage_exactly_100
    if self.materials == nil
      return
    end
   if self.materials.any?{|m| m.percentage == nil}
    return
   end
   unless self.materials.select {|m| m.percentage != nil}.sum(&:percentage) == 100
    errors.add(:building_wall, "Must be 100%")
   end
  end
end
