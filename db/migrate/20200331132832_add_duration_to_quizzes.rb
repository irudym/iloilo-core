class AddDurationToQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :duration, :integer, default: 10
  end
end
