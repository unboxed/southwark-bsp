class RemovePercentageFromMaterials < ActiveRecord::Migration[6.0]
  def change
    change_table :materials do |t|
      t.remove :percentage
      t.remove :insulation_material
      t.remove :insulation_details
    end
  end
end
