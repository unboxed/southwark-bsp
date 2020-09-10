class CreateBuildingWallMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :building_wall_materials do |t|
      t.references :building_wall, null: false, foreign_key: true
      t.jsonb :material, default: {}
      t.timestamps
    end
  end
end
