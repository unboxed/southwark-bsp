class AddCompletedToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :completed, :boolean
    add_column :surveys, :completed_at, :datetime, precision: 6
  end
end
