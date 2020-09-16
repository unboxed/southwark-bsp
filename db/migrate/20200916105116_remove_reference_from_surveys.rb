class RemoveReferenceFromSurveys < ActiveRecord::Migration[6.0]
  def change
    remove_column :surveys, :reference_id
  end
end
