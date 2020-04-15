class AddQuesitonReferencesToQuizResponses < ActiveRecord::Migration[6.0]
  def change
    add_reference :quiz_responses, :question, null: false, foreign_key: true
  end
end
