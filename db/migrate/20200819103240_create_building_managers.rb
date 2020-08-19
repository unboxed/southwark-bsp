class CreateBuildingManagers < ActiveRecord::Migration[6.0]
  enable_extension "citext" unless extension_enabled? "citext"

  def change
    create_table :building_managers do |t|
      t.citext :email, null: false, index: true

      t.timestamps
    end
  end
end
