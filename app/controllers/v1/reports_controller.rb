class V1::ReportsController < ApplicationController
  before_action :set_active_quiz, only: [:show]

  def show

    by_user = @activeQuiz.report_by_user

    response = {
      data: {
        type: "report",
        attributes: by_user
      }
    }
    render json: response.to_json
  end

  private

  def set_active_quiz
    # check if active quiz belongs to current user
    if !@current_user.active_quizzes.exists?(params[:id]) 
      raise(ActiveRecord::RecordNotFound, Message.wrong_quiz_id) 
    end
    @activeQuiz = ActiveQuiz.find(params[:id])
  end

end
