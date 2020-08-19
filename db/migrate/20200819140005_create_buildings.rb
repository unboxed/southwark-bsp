class CreateBuildings < ActiveRecord::Migration[6.0]
  def change
    create_table :buildings do |t|
      t.string :address, null: false
      t.bigint :UPRN

      t.timestamps
    end
  end
end
