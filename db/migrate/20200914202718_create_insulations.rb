class CreateInsulations < ActiveRecord::Migration[6.0]
  def change
    create_table :insulations do |t|
      t.references :material, null: false, foreign_key: true, index: { name: 'insulation_index' }
      t.string :insulation_material
      t.text :insulation_details

      t.timestamps
    end
  end
end
