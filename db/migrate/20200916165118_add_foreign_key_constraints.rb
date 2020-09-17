class AddForeignKeyConstraints < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :insulations, :materials, null: false, foreign_key: true, on_delete: :cascade
    add_foreign_key :percentages, :materials, null: false, foreign_key: true, on_delete: :cascade
  end
end
