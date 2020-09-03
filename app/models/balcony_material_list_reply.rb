class BalconyMaterialListReply
  attr_reader :material_detail_list, :primary_materials, :floor_materials, :railing_materials

  def initialize(material_detail_list)
    @material_detail_list = material_detail_list
    @primary_materials = []
    @floor_materials = []
    @railing_materials = []
  end

  def render
    {
      "Primary materials": add_primary_materials,
      "Floor materials": add_floor_materials,
      "Railings/balustrades": add_railing_materials
    }
  end

  private

    def add_primary_materials
      primary_materials.tap do |primary_material_list|
        primary_material_list.push "Timber or wood" if material_detail_list.has_timber_or_wood_primary_material?
        primary_material_list.push "Glass" if material_detail_list.has_glass_primary_material?
        primary_material_list.push "Metal" if material_detail_list.has_metal_primary_material?
        primary_material_list.push "Concrete" if material_detail_list.has_concrete_primary_material?
        primary_materials_list.push "Unknown" if material_detail_list.has_unknown_primary_material?
        primary_materials_list.push "Other (#{material_detail_list.other_primary_material_details})" if material_detail_list.has_other_primary_material?
      end.join(", ")
    end

    def add_floor_materials
      floor_materials.tap do |floor_material_list|
        floor_material_list.push "Timber or wood" if material_detail_list.has_timber_or_wood_floor_material?
        floor_material_list.push "Glass" if material_detail_list.has_glass_floor_material?
        floor_material_list.push "Metal" if material_detail_list.has_metal_floor_material?
        floor_material_list.push "Concrete" if material_detail_list.has_concrete_floor_material?
        floor_material_list.push "Unknown" if material_detail_list.has_unknown_floor_material?
        floor_material_list.push "Other (#{material_detail_list.other_floor_material_details})" if material_detail_list.has_other_floor_material?
      end.join(", ")
    end

    def add_railing_materials
      railing_materials.tap do |railing_material_list|
        railing_material_list.push "Timber or wood" if material_detail_list.has_timber_or_wood_railing_material?
        railing_material_list.push "Glass" if material_detail_list.has_glass_railing_material?
        railing_material_list.push "Metal" if material_detail_list.has_metal_railing_material?
        railing_material_list.push "Concrete" if material_detail_list.has_concrete_railing_material?
        railing_material_list.push "Unknown" if material_detail_list.has_unknown_railing_material?
        railing_material_list.push "Other (#{material_detail_list.other_railing_material_details})" if material_detail_list.has_other_railing_material?
      end.join(", ")
    end
end
