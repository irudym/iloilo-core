class AddMaxScoreToQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :max_score, :integer, default: 100
  end
end
