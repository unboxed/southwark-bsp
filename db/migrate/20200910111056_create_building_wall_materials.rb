class CreateBuildingWallMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :building_wall_materials do |t|
      t.references :building_wall, null: false, foreign_key: true, index: { name: 'material_index' }
      t.string :material
      t.string :other_material
      t.timestamps
    end
  end
end
