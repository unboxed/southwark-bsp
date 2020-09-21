class MaterialDetailList < ApplicationRecord
  belongs_to :building_external_wall_structure

  validates :external_structure_name, presence: true, inclusion: { in: %w(balcony solar_shading) }
  validates :other_primary_material_details, presence: { message: "can't be blank. Please fill in the other details text field." }, if: -> { has_other_primary_material? }
  validates :other_floor_material_details, presence: { message: "can't be blank. Please fill in the floor details text field." }, if: -> { has_other_floor_material? }
  validates :other_railing_material_details, presence: { message: "can't be blank. Please fill in the railing details text field." }, if: -> { has_other_railing_material? }

  validate :has_materials_for_external_structures
  validate :has_one_primary_material_for_balcony, if: -> { external_structure_name == "balcony" }

  def reply
    "#{external_structure_name.classify}MaterialListReply".constantize.new(self).render
  end

  private
    def has_materials_for_external_structures
      if has_timber_or_wood_primary_material ||
        has_timber_or_wood_floor_material ||
        has_timber_or_wood_railing_material ||
        has_glass_primary_material ||
        has_glass_floor_material ||
        has_glass_railing_material ||
        has_metal_primary_material ||
        has_metal_floor_material ||
        has_metal_railing_material ||
        has_concrete_primary_material ||
        has_concrete_floor_material ||
        has_concrete_railing_material ||
        has_unknown_primary_material ||
        has_unknown_floor_material ||
        has_unknown_railing_material ||
        has_other_primary_material ||
        has_other_floor_material ||
        has_other_railing_material
      else
        errors.add(:base, "Please select at least one option")
      end
    end

    def has_one_primary_material_for_balcony
      material_count = [
        has_timber_or_wood_primary_material,
        has_glass_primary_material?,
        has_metal_primary_material?,
        has_concrete_primary_material?,
        has_unknown_primary_material?,
        has_other_primary_material?].count(&:itself)
      if material_count > 1
        errors.add(:primary_materials, ": Single select. Please select only one option for balcony primary materials")
      end
    end
end
