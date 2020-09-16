class AddProprietorEmailToBuildings < ActiveRecord::Migration[6.0]
  def change
    remove_column :buildings, :manager_id, :bigint
    add_column :buildings, :proprietor_email, :citext
  end
end
