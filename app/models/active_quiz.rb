class ActiveQuiz < ApplicationRecord
  extend PinGenerator
  belongs_to :quiz
  belongs_to :user
  has_many :connections
  has_many :quiz_responses

  def self.create! params
    # check if the quiz activated - DEPRECATED an user may activate at quiz as many as needed!
    # activeQuiz = ActiveQuiz.where(quiz_id: params[:quiz_id])
    # unless activeQuiz.empty?
    #  activeQuiz.each do |a_quiz|
    #    if a_quiz.started 
    #      raise(ExceptionHandler::CannotUpdate, Message.quiz_started) 
    #    end
    #  end
    # end
    # TODO: check that pin is uniq
    params[:pin] = pin
    super params
  end

  def start!
    ended_at = Time.now + duration
    self.update!(started: true, ended_at: ended_at) 
  end

  def duration
    self.quiz.duration
  end

  def title
    self.quiz.title
  end

  def description
    self.quiz.description
  end

  def connected_users
    Connection.connected_users(self)
  end
end
