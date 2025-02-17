class AddNotNullToOnDeltaColumn < ActiveRecord::Migration[6.1]
  def change
    change_column_null :buildings, :on_delta, false, false
  end
end
