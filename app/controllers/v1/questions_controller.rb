class V1::QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy, :restore]

  def index
    # TODO: show only questions which belong to the current user
    questions = Question.all 
    render json: QuestionSerializer.new(questions)
  end

  def show
    render json: QuestionSerializer.new(@question)
  end

  def create
    quiz = Quiz.find(params[:data][:relationships][:quiz][:data][:id])
    # check if the quiz belongs to the current user, otherwise don't create a question
    unless @current_user.quizzes.exists?(quiz.id) 
      raise(ActiveRecord::RecordNotFound, Message.wrong_quiz_id) 
    end

    question = Question.create!(text: question_params[:text], quiz: quiz)

    # add_answers(params, question)
    question.create_answers params[:data][:relationships]

    # Render serialized json response
    render json: QuestionSerializer.new(question), status: 201
  end

  def update
    @question.update!(question_params)

    @question.update_answers params[:data][:relationships] if params[:data][:relationships]
    render json: QuestionSerializer.new(@question), status: 201
  end

  def destroy
    @question.destroy_with_answers
    head :no_content
  end

  private

  def set_question
    @question = Question.find(params[:id])
    
    # check if the question's quiz belongs to the current user
    if !@current_user.quizzes.exists?(@question.quiz.id) 
      raise(ActiveRecord::RecordNotFound, Message.wrong_quiz_id) 
    end
  end

  def question_params
    # whitelist params
    params.require(:data).require(:attributes).permit(:text, :quiz)
  end

end
