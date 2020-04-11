class AddReferenceToQuizToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :quiz, null: false, foreign_key: true
  end
end
