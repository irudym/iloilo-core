class MakeQuizNullableInQuestions < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:questions, :quiz_id, true)
  end
end
