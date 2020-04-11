class AddQuizReferenceToActiveQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_reference :active_quizzes, :quiz, null: false, foreign_key: true
  end
end
