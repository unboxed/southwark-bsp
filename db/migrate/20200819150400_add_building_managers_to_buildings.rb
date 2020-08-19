class AddBuildingManagersToBuildings < ActiveRecord::Migration[6.0]
  def change
    add_reference :buildings, :manager, foreign_key: { to_table: :building_managers }
  end
end
