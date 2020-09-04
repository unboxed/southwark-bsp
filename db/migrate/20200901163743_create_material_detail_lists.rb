class CreateMaterialDetailLists < ActiveRecord::Migration[6.0]
  def change
    create_table :material_detail_lists do |t|
      t.references :building_external_wall_structure, null: false, foreign_key: true, index: { name: "index_detail_list_on_wall_structure_id" }
      t.string :external_structure_name, null: false, default: ""
      t.boolean :has_timber_or_wood_primary_material, null: false, default: false
      t.boolean :has_timber_or_wood_floor_material, null: false, default: false
      t.boolean :has_timber_or_wood_railing_material, null: false, default: false
      t.boolean :has_glass_primary_material, null: false, default: false
      t.boolean :has_glass_floor_material, null: false, default: false
      t.boolean :has_glass_railing_material, null: false, default: false
      t.boolean :has_metal_primary_material, null: false, default: false
      t.boolean :has_metal_floor_material, null: false, default: false
      t.boolean :has_metal_railing_material, null: false, default: false
      t.boolean :has_concrete_primary_material, null: false, default: false
      t.boolean :has_concrete_floor_material, null: false, default: false
      t.boolean :has_concrete_railing_material, null: false, default: false
      t.boolean :has_unknown_primary_material, null: false, default: false
      t.boolean :has_unknown_floor_material, null: false, default: false
      t.boolean :has_unknown_railing_material, null: false, default: false
      t.boolean :has_other_primary_material, null: false, default: false
      t.boolean :has_other_floor_material, null: false, default: false
      t.boolean :has_other_railing_material, null: false, default: false
      t.string :other_primary_material_details
      t.string :other_floor_material_details
      t.string :other_railing_material_details

      t.timestamps
    end
  end
end
