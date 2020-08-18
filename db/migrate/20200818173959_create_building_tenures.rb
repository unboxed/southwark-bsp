class CreateBuildingTenures < ActiveRecord::Migration[6.0]
  def change
    create_table :building_tenures do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :tenure_type, null: false, default: 0
      t.timestamps
    end
  end
end
