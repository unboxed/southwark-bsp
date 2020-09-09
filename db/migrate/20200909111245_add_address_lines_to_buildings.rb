class AddAddressLinesToBuildings < ActiveRecord::Migration[6.0]
  def change
    add_column :buildings, :street, :string
    add_column :buildings, :city_town, :string
    add_column :buildings, :postcode, :string
  end
end
