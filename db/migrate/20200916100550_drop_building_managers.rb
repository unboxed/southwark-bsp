class DropBuildingManagers < ActiveRecord::Migration[6.0]
  def up
    remove_index :buildings, :manager_id
    remove_foreign_key :buildings, :building_managers
    drop_table :building_managers
  end

  def down
    create_table :building_managers do |t|
      t.citext :email, null: false, index: true

      t.timestamps
    end
  end
end
