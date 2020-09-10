class BuildingWallMaterialPercentages < ActiveRecord::Migration[6.0]
  def change
    create_table :building_wall_material_percentages do |t|
      t.references :building_wall_material, null: false, foreign_key: true, index: { name: 'percentage_index' }
      t.integer :material_percentage
      t.timestamps
    end
  end
end
