class CreateBuildingHeights < ActiveRecord::Migration[6.0]
  def change
    create_table :building_heights do |t|
      t.references :survey, null: false, foreign_key: true
      t.boolean :higher_than_18_meters
      t.integer :height_in_meters
      t.integer :height_in_storeys

      t.timestamps
    end
  end
end
