class CorrectAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :answer
  
  def answer_id
    answer.id
  end
end
