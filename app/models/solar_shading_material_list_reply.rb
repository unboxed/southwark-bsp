class SolarShadingMaterialListReply
  attr_reader :material_detail_list, :primary_materials

  def initialize(material_detail_list)
    @material_detail_list = material_detail_list
    @primary_materials = []
  end

  def render
    primary_materials.tap do |primary_material_list|
      primary_material_list.push "Timber or wood" if material_detail_list.has_timber_or_wood_primary_material?
      primary_material_list.push "Glass" if material_detail_list.has_glass_primary_material?
      primary_material_list.push "Metal" if material_detail_list.has_metal_primary_material?
      primary_material_list.push "Concrete" if material_detail_list.has_concrete_primary_material?
      primary_material_list.push "Unknown" if material_detail_list.has_unknown_primary_material?
      primary_material_list.push "Other (#{material_detail_list.other_primary_material_details})" if material_detail_list.has_other_primary_material?
    end.join(", ")
  end
end
