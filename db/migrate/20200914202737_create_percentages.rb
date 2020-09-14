class CreatePercentages < ActiveRecord::Migration[6.0]
  def change
    create_table :percentages do |t|
      t.references :material, null: false, foreign_key: true, index: { name: 'percentage_index' }
      t.integer :material_percentage

      t.timestamps
    end
  end
end
