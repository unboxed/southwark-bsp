class CreateBuildingWallMaterialPercentages < ActiveRecord::Migration[6.0]
  def change
    create_table :building_wall_material_percentages do |t|
      t.references :building_wall_material, null: false, foreign_key: true, index: { name: 'percentage_index' }
      t.timestamps
    end
  end
end
