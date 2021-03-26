class DropExistingModels < ActiveRecord::Migration[6.1]
  def change
    drop_table :sections do |t|
      t.references :survey, null: false, index: true, foreign_key: true
      t.string :content_type
      t.bigint :content_id
      t.timestamps
    end

    drop_table :material_detail_lists do |t|
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

    drop_table :building_external_wall_structures do |t|
      t.references :survey, null: false, foreign_key: true
      t.boolean :has_balconies, null: false, default: false
      t.boolean :has_solar_shading, null: false, default: false
      t.boolean :has_green_walls, null: false, default: false
      t.boolean :has_no_external_structures, null: false, default: false
      t.boolean :has_other_structure, null: false, default: false
      t.string :other_structure_details
      t.timestamps
    end

    drop_table :building_heights do |t|
      t.references :survey, null: false, foreign_key: true
      t.boolean :higher_than_18_meters
      t.integer :height_in_meters
      t.integer :height_in_storeys
      t.timestamps
    end

    drop_table :building_statuses do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :status_details
      t.timestamps
    end

    drop_table :building_ownerships do |t|
      t.integer :ownership_status
      t.references :survey, null: false, foreign_key: true
      t.text :ownership_details
      t.timestamps
      t.boolean :right_to_manage_company
      t.string :full_name
      t.string :email
      t.string :organisation
    end

    drop_table :building_tenures do |t|
      t.integer :tenure_type
      t.references :survey, null: false, foreign_key: true
      t.timestamps
    end

    drop_table :insulations do |t|
      t.references :material, null: false, foreign_key: { on_delete: :cascade }, index: { name: 'insulation_index' }
      t.string :insulation_material
      t.text :insulation_details
      t.timestamps
    end

    drop_table :percentages do |t|
      t.references :material, null: false, foreign_key: { on_delete: :cascade }, index: { name: 'percentage_index' }
      t.integer :material_percentage
      t.timestamps
    end

    drop_table :materials do |t|
      t.references :building_wall, null: false, foreign_key: true
      t.string :name
      t.text :details
      t.timestamps
      t.text :comments
    end

    drop_table :building_walls do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :material_quantity
      t.timestamps
    end

    drop_table :surveys do |t|
      t.references :building, null: false, foreign_key: true
      t.timestamps
    end
  end
end
