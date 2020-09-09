class ChangeAddressToBuildingNameInBuildingsTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :buildings, :address, :building_name
  end
end
