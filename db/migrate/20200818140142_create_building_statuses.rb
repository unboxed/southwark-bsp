class CreateBuildingStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :building_statuses do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :status_details
      t.timestamps
    end
  end
end
