class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :building, null: false, foreign_key: true, on_delete: :cascade
      t.string :notification_mean, null: false, default: ""
      t.string :state, null: false, default: "created"
      t.datetime :enqueued_at
      t.datetime :sent_at
      t.datetime :delivered_at
      t.datetime :failed_at
      t.string :notify_id
      t.string :notify_uri

      t.timestamps
    end
  end
end
