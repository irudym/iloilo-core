class V1::QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :update, :destroy, :restore]

  def index
    quizzes = @current_user.quizzes
    render json: QuizSerializer.new(quizzes)
  end

  def show
    options = {}
    options[:include] = [:questions, :'questions.answers']
    options[:params] = { :admin => @current_user.is_admin? }
    render json: QuizSerializer.new(@quiz, options)
  end

  def create
    quiz = Quiz.create!(quiz_params.merge(user: @current_user))

    # create questions if provided
    quiz.create_questions(params[:data][:relationships]) if params[:data][:relationships]

    render json: QuizSerializer.new(quiz), status: 201
  end

  def update
    @quiz.update!(quiz_params)
    #update quiestions if provided
    @quiz.update_questions params[:data][:relationships] if params[:data][:relationships]

    render json: QuizSerializer.new(@quiz), status: 201
  end

  def destroy
    @quiz.destroy_with_questions
    head :no_content
  end

  private

  def set_quiz
    # check if the quiz belongs to the current user
    if !@current_user.quizzes.exists?(params[:id]) 
      raise(ActiveRecord::RecordNotFound, Message.wrong_quiz_id) 
    end
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    # whitelist params
    params.require(:data).require(:attributes).permit(:title, :description, :duration)
  end
end
