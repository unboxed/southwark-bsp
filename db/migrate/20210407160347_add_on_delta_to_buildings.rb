class AddOnDeltaToBuildings < ActiveRecord::Migration[6.1]
  def change
    add_column :buildings, :on_delta, :integer
  end
end
