class Dropmaterials < ActiveRecord::Migration[6.0]
  def change
    drop_table :materials
  end
end
