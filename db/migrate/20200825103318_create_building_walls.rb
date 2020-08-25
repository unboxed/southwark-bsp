class CreateBuildingWalls < ActiveRecord::Migration[6.0]
  def change
    create_table :building_walls do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :material_quantity
      t.timestamps
    end
  end
end
