class AddUserReferencesToActiveQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_reference :active_quizzes, :user, null: true, foreign_key: true
  end
end
