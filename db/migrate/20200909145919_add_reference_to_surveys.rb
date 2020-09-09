class AddReferenceToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :reference_id, :string
  end
end
