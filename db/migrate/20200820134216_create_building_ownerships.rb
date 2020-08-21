class CreateBuildingOwnerships < ActiveRecord::Migration[6.0]
  def change
    create_table :building_ownerships do |t|
      t.integer :ownership_status
      t.references :survey, null: false, foreign_key: true
      t.text :ownership_details
      t.timestamps
    end
  end
end
