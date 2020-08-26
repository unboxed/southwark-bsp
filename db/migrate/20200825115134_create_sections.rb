class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.references :survey, null: false, foreign_key: true
      t.string :content_type
      t.bigint :content_id

      t.timestamps
    end
  end
end
