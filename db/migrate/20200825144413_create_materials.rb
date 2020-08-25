class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.references :building_wall, null: false, foreign_key: true
      t.string :name
      t.text :details
      t.integer :percentage
      t.string :insulation_material
      t.text :insulation_details

      t.timestamps
    end
  end
end
