class AddTrackableColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at, :last_sign_in_at
      t.inet     :current_sign_in_ip, :last_sign_in_ip
    end
  end
end
