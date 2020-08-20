class CreateBuildingTenures < ActiveRecord::Migration[6.0]
  def change
    create_table :building_tenures do |t|
      t.integer :tenure_type
      t.references :survey, null: false, foreign_key: true
      t.timestamps
    end
  end
end
