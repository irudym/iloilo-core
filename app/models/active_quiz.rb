class ActiveQuiz < ApplicationRecord
  extend PinGenerator
  belongs_to :quiz
  belongs_to :user
  has_many :connections
  has_many :quiz_responses

  def self.create! params
    begin
      generated_pin = pin
    end while ActiveQuiz.exists?(pin: generated_pin)
    params[:pin] = generated_pin
    quiz = Quiz.find(params[:quiz_id])
    params[:duration] = quiz.duration unless params[:duration]
    super params
  end

  def start! params
    # override duration in case provided
    duration = self.duration
    duration = params[:data][:attributes][:duration].to_i if params[:data][:attributes] and params[:data][:attributes][:duration]
    comment = params[:data][:attributes][:comment] if params[:data][:attributes]
    ended_at = DateTime.current + duration.minutes
    self.update!(started: true, ended_at: ended_at, duration: duration, comment: comment) 
  end

  def is_valid
    return true unless self.ended_at
    DateTime.current <= self.ended_at
  end

  # def duration
  #  self.quiz.duration
  # end

  def title
    self.quiz.title
  end

  def description
    self.quiz.description
  end

  def max_score
    self.quiz.max_score
  end

  def question_ids
    # next_question = quiz.questions.where(not answered).order('RAND()').limit(1).first
    # questions = QuizResponse for this user and for this ActiveQuiz (self)
    @question = quiz.questions.order('RAND()').limit(1).first
    [@question.id]
  end

  def questions
    [@question]
  end

  def connected_users
    Connection.connected_users(self)
  end

  def submitted_users
    users = QuizResponse.where(active_quiz: self).distinct.pluck(:user_id)
    response = User.where(id: users).map do |user|
      {
        id: user.id,
        name: "#{user.first_name} #{user.last_name}",
        score: user_score(user)
      }
    end
    response
  end

  def user_score (user)
    user_score = QuizResponse.user_score(user: user, active_quiz: self)
    question_count = self.quiz.questions.count
    max_score = self.quiz.max_score
    max_score = 100 if max_score == 0
    # puts "\nLOG[ActiveQuizModel]: user_score=#{user_score}  count=#{question_count}   max_score=#{max_score}"
    ((user_score.to_f / question_count.to_f) * max_score.to_f).to_i
  end

  def report_by_user
    question_count = 0;
    total_questions = self.quiz.questions.count

    by_users = self.submitted_users.inject([]) do |acc, user|
      responses = QuizResponse.where(user_id: user[:id], active_quiz: self)
      questions = responses.inject([]) do |accul, response|
        if response.question.quiz_id
          question_count += 1
        end
        accul << {
          id: response.question.id,
          text: response.question.text,
          deleted: !response.question.quiz_id,
          correct_count: response.question.correct_answers_count,
          answer_count: response.question.answers.count,
          answers: response.answers.inject([]) do |accumul, answer|
            accumul << {
              id: answer.id,
              text: answer.text,
              correct: answer.correct
            }
            accumul
          end
        }
        accul
      end
      acc << {
        user_id: user[:id],
        user: user[:name],
        score: user[:score],
        questions: questions
      }
      acc
    end
  end
end
