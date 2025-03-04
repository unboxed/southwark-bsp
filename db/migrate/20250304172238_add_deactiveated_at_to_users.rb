class AddDeactiveatedAtToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.datetime :deactivated_at
    end
  end
end
