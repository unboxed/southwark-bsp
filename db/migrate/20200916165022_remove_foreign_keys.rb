class RemoveForeignKeys < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :insulations, :materials
    remove_foreign_key :percentages, :materials
  end
end
