class CreateBuildingExternalWallStructures < ActiveRecord::Migration[6.0]
  def change
    create_table :building_external_wall_structures do |t|
      t.references :survey, null: false, foreign_key: true
      t.boolean :has_balconies, null: false, default: false
      t.boolean :has_solar_shading, null: false, default: false
      t.boolean :has_green_walls, null: false, default: false
      t.boolean :has_no_external_structures, null: false, default: false
      t.boolean :has_other_structure, null: false, default: false
      t.string :other_structure_details

      t.timestamps
    end
  end
end
