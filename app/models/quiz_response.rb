class QuizResponse < ApplicationRecord
  belongs_to :user
  belongs_to :active_quiz
  belongs_to :question
  has_and_belongs_to_many :answers

  def self.create_with_questions(user:, quiz:, questions: [], score: 0)
    answers = questions.inject([]) do |accumul, question|
      q = Question.find(question[:id])
      # extract answers ids
      answersIds = []
      if question[:relationships][:answers]
        answersIds = (question[:relationships][:answers][:data] || []).inject([]) do |acc, answer|
          acc << answer[:id] if answer[:attributes][:correct]
          acc
        end
      end
      accumul.concat(Answer.where(id: answersIds))
      accumul
    end
    qr = QuizResponse.create!(user: user, active_quiz: quiz, score: score, answers: answers)
    qr
  end

  def self.user_score(user:, active_quiz: )
    QuizResponse.where(user: user, active_quiz: active_quiz).inject(0) do |acc, resp|
      acc += resp.score if resp.score
      acc
    end
  end
end
