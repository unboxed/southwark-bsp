class BuildingExternalWallStructure < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content
  has_one :balcony_material_detail_list, -> { where(external_structure_name: "balcony") }, class_name: "MaterialDetailList"
  has_one :solar_shading_material_detail_list, -> { where(external_structure_name: "solar_shading") }, class_name: "MaterialDetailList"

  validate :has_external_structures_associated

  def name
    "External walls structures"
  end

  def reply
    [self].inject([]) do |replies, external_wall|
      replies.push "Balconies" if external_wall.has_balconies?
      replies.push "Solar shading" if external_wall.has_solar_shading?
      replies.push "Green walls" if external_wall.has_green_walls?
      replies.push "Other structure" if external_wall.has_other_structure?
      replies.push "No external structures" if external_wall.has_no_external_structures?
      replies
    end.compact.join(", ")
  end

  def should_terminate_survey?
    true if complete?
  end

  def incomplete?
    !complete?
  end

  def complete?
    next_required_detail.nil?
  end

  def next_required_detail
    if has_balconies? && !has_balcony_material_detail_list?
      :balcony
    elsif has_solar_shading? && !has_solar_shading_material_detail?
      :solar_shading
    else
      nil
    end
  end

  private

    def has_solar_shading_material_detail?
      solar_shading_material_detail_list.present?
    end

    def has_balcony_material_detail_list?
      balcony_material_detail_list.present?
    end

    def has_external_structures_associated
      unless [has_balconies?, has_solar_shading?, has_green_walls?, has_no_external_structures?, has_other_structure?].any?
        errors.add(:external_structures, "Please select at least one option")
      end
    end
end
