class V1::AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy, :restore]

  def index
    answers = Answer.all
    render json: AnswerSerializer.new(answers)
  end

  def show
    render json: AnswerSerializer.new(@answer)
  end

  def update
    @answer.update(answer_params)
    render json: AnswerSerializer.new(@answer)
  end

  private 

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:data).require(:attributes).permit(:text, :question_id, :correct)
  end
end
