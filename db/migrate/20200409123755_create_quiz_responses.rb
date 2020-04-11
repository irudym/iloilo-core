class CreateQuizResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :quiz_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :active_quiz, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end

    create_table :answers_quiz_responses, id: false do |t|
      t.belongs_to :answer
      t.belongs_to :quiz_response
    end
  end
end
