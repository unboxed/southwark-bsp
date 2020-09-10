class CreateBuildingWallMaterialInsulations < ActiveRecord::Migration[6.0]
  def change
    create_table :building_wall_material_insulations do |t|
      t.references :building_wall_material, null: false, foreign_key: true, index: { name: 'insulation_index' }
      t.timestamps
    end
  end
end
