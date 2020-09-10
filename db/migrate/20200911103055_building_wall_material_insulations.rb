class BuildingWallMaterialInsulations < ActiveRecord::Migration[6.0]
  def change
    create_table :building_wall_material_insulations do |t|
      t.references :building_wall_material, null: false, foreign_key: true, index: { name: 'insulation_index' }
      t.string :insulation_material
      t.text :insulation_details
      t.timestamps
    end
  end
end
