class CreateActiveQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :active_quizzes do |t|
      t.string :pin
      t.boolean :started, default: false
      t.datetime :ended_at
      t.timestamps
    end
  end
end
