class CreateSurveyRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_records do |t|
      t.references :building, index: true, foreign_key: true
      t.string :session_id, null: false, index: { unique: true }
      t.string :stage, null: false, limit: 50, default: "uprn"
      t.jsonb :data, null: false, default: {}
      t.datetime :completed_at
      t.datetime :submitted_at
      t.timestamps
    end
  end
end
