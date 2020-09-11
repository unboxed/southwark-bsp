class ChangeNameInBuildingOwnership < ActiveRecord::Migration[6.0]
  def change
    rename_column :building_ownerships, :name, :full_name
  end
end
