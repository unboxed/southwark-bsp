class AddDefaultToMostRecentColumn < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:building_survey_transitions, :most_recent, from: nil, to: false)
  end
end
