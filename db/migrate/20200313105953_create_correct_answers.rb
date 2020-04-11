class CreateCorrectAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :correct_answers do |t|
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
