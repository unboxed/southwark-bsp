class RemoveNullConstraintOnSessionId < ActiveRecord::Migration[6.1]
  def change
    change_column_null :survey_records, :session_id, true
  end
end
