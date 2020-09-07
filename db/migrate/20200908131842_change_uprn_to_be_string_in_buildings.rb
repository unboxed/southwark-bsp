class ChangeUprnToBeStringInBuildings < ActiveRecord::Migration[6.0]
  def change
    change_column :buildings, :uprn, :string
  end
end
