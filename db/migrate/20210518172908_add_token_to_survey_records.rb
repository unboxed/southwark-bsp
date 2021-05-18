class AddTokenToSurveyRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_records, :token, :string
  end
end
