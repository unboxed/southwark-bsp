class MaterialDetailList < ApplicationRecord
  belongs_to :building_external_wall_structure

  validates :external_structure_name, presence: true, inclusion: { in: %w(balcony solar_shading) }

  def reply
    "#{external_structure_name.classify}MaterialListReply".constantize.new(self).render
  end
end
