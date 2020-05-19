class AddCommentToActiveQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :active_quizzes, :comment, :text
  end
end
