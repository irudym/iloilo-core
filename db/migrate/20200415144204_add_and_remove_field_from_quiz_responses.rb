class AddAndRemoveFieldFromQuizResponses < ActiveRecord::Migration[6.0]
  def change
    remove_column :quiz_responses, :question_id
    add_column :quiz_responses, :score, :bigint
  end
end
