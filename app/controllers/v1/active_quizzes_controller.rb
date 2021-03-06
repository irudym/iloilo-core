class V1::ActiveQuizzesController < ApplicationController
  before_action :set_active_quiz, only: [:show, :update, :destroy, :restore]
  before_action :set_options, only: [:index, :create, :update, :show]

  def index
    activeQuizzes = @current_user.active_quizzes.order(created_at: :desc)
    render json: ActiveQuizSerializer.new(activeQuizzes, @options)
  end

  def create
    #check if related quiz belongs to the current user
    if !@current_user.quizzes.exists?(active_quiz_params[:quiz_id]) 
      raise(ActiveRecord::RecordNotFound, Message.wrong_quiz_id) 
    end

    @activeQuiz = ActiveQuiz.create!(active_quiz_params.merge(user: @current_user))
    render json: ActiveQuizSerializer.new(@activeQuiz, @options), status: 201
  end

  def update
    @activeQuiz.start! params
    render json: ActiveQuizSerializer.new(@activeQuiz, @options), status: 201
  end

  def show
    render json: ActiveQuizSerializer.new(@activeQuiz, @options)
  end

  def destroy
    @activeQuiz.destroy
    head :no_content
  end

  private 

  def set_options
    @options = {}
    @options[:params] = { :admin => @current_user.is_admin? }
  end
  
  def active_quiz_params
    relationships = params.require(:data).require(:relationships).permit(:quiz_id)
    attributes = params.require(:data).permit(:attributes).permit(:duration).permit(:comment)
    relationships.merge(attributes)
  end

  def set_active_quiz
    # check if active quiz belongs to current user
    if !@current_user.active_quizzes.exists?(params[:id]) 
      raise(ActiveRecord::RecordNotFound, Message.wrong_quiz_id) 
    end
    @activeQuiz = ActiveQuiz.find(params[:id])
  end

end
