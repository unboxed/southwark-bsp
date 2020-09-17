class AddAdditionalFieldsToBuildings < ActiveRecord::Migration[6.0]
  def up
    add_index :buildings, :uprn, unique: true
    add_column :buildings, :land_registry_title_number, :string
    add_column :buildings, :land_registry_proprietor_name, :string
    add_column :buildings, :land_registry_proprietor_address, :string
    add_column :buildings, :land_registry_proprietor_category, :string
    add_column :buildings, :land_registry_proprietor_company_registration_number, :string
    change_column :buildings, :building_name, :string, null: true
    change_column :buildings, :created_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
    change_column :buildings, :updated_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
  end

  def down
    change_column :buildings, :updated_at, :datetime, precision: 6, null: false, default: nil
    change_column :buildings, :created_at, :datetime, precision: 6, null: false, default: nil
    change_column :buildings, :building_name, :string, null: false
    remove_column :buildings, :land_registry_title_number, :string
    remove_column :buildings, :land_registry_proprietor_name, :string
    remove_column :buildings, :land_registry_proprietor_address, :string
    remove_column :buildings, :land_registry_proprietor_category, :string
    remove_column :buildings, :land_registry_proprietor_company_registration_number, :string
    remove_index :buildings, :uprn
  end
end
