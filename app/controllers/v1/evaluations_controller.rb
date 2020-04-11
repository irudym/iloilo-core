class V1::EvaluationsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_user

  def show
    # create connection
    # show information about active_quiz
    quiz = ActiveQuiz.find_by(pin: params[:id])
    Connection.create!(user: @current_user, active_quiz: quiz)
    options = {}
    options[:params] = { :hide_quiz => true }

    # TODO: need to remoe information about users in the active quiz
    render json: ActiveQuizSerializer.new(quiz, options)
  end

  def quiz
    quiz = ActiveQuiz.find_by(pin: params[:pin])
    # update connection
    Connection.create!(user: @current_user, active_quiz: quiz)

    #check if quiz started
    options = {}
    options[:include] = [:quiz, :'quiz.questions', :'quiz.questions.answers'] if quiz.started
    options[:params] = { :admin => false }
    render json: ActiveQuizSerializer.new(quiz, options)
  end


end
