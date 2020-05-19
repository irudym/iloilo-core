class AddDurationToActiveQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :active_quizzes, :duration, :integer
  end
end
