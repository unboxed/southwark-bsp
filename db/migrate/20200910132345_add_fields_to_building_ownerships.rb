class AddFieldsToBuildingOwnerships < ActiveRecord::Migration[6.0]
  def change
    add_column :building_ownerships, :right_to_manage_company, :boolean
    add_column :building_ownerships, :name, :string
    add_column :building_ownerships, :email, :string
    add_column :building_ownerships, :organisation, :string
  end
end
