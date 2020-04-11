class QuizResponse < ApplicationRecord
  belongs_to :user
  belongs_to :active_quiz
  belongs_to :question
  has_and_belongs_to_many :answers
end
