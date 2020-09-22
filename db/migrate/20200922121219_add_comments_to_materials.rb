class AddCommentsToMaterials < ActiveRecord::Migration[6.0]
  def change
    add_column :materials, :comments, :text
  end
end
