class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :buildings, :UPRN, :uprn
  end
end
