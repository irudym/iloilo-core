class V1::EvaluationsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_user
  before_action :set_quiz, only: [:show, :assess, :quiz]


  def show
    # create connection
    # show information about active_quiz
    Connection.create!(user: @current_user, active_quiz: @quiz)
    options = {}
    options[:params] = { :hide_quiz => true }

    submitted_questions = QuizResponse.where(user: @current_user, active_quiz: @quiz).map do |resp|
      resp.question.id
    end
    questions = @quiz.quiz.questions.where.not(id: submitted_questions)
    response = {}

    if questions.empty?
      final_score = @quiz.user_score(@current_user)
      response = {
        data: {
          type: "evaluation",
          attributes: {
            score: final_score
          } 
        }
      }.to_json
      else
        response = ActiveQuizSerializer.new(@quiz, options)
      end
    # TODO: need to remoe information about users in the active quiz
    render json: response
  end

  def quiz
    # update connection
    Connection.create!(user: @current_user, active_quiz: @quiz)

    response = {}
      #check if quiz started
      options = {}
      unless @quiz.is_valid
        # TODO may skip it as all quizes tracked by ended_at field
        @quiz.update!(started: false)
        raise(ExceptionHandler::QuizInactive, Message.quiz_inactive)
      end
      options[:include] = [:'questions', :'questions.answers'] if @quiz.started
      options[:params] = { :admin => false, :show_questions => true }
      response = ActiveQuizSerializer.new(@quiz, options)
    #end

    render json: response
  end

  def assess
    # check if quiz started
    unless @quiz.started
      raise(ExceptionHandler::QuizInactive, Message.quiz_inactive)
    end

    response = {}
    # check if the quiz is still running
    if @quiz.is_valid
      params[:data][:relationships][:questions][:data].each do |provided_question|
        # check if an aswers already submitted for the question
        question = Question.find(provided_question[:id])
        if QuizResponse.where(user: @current_user, active_quiz: @quiz, question: question).empty?

          score = question.evaluate(provided_question[:relationships][:answers][:data])
          if score[:score] == -1
            logger.debug "[CoreError]: at EvaluationsController#assess provided quesiton without answers: 
              #{provided_question[:relationships][:answers][:data].to_json}" 
            raise(ExceptionHandler::AnswerMissed, Message.no_answers)  
          end
          
          # create a response record
          answers = Answer.where(id: score[:answers])
          QuizResponse.create!(user: @current_user, active_quiz: @quiz, question: question, score: score[:score], answers: answers)
        end
      end
      
      submitted_questions = QuizResponse.where(user: @current_user, active_quiz: @quiz).map do |resp|
        resp.question.id
      end

      
      # find next question
      next_question = @quiz.quiz.questions.where.not(id: submitted_questions).order('RAND()').limit(1)
      unless next_question.empty? 
        options = {}
        options[:include] = [:answers]
        response = QuestionSerializer.new(next_question.first, options)
      else
        final_score = @quiz.user_score(@current_user)
        response = {
          data: {
            type: "evaluation",
            attributes: {
              score: final_score
            } 
          }
        }
      end
    else
      # in case the time is out - just show immidiate result
      final_score = @quiz.user_score(@current_user)
        response = {
          data: {
            type: "evaluation",
            attributes: {
              score: final_score
            } 
          }
        }        
    end
    render json: response.to_json 
  end

  private

  def set_quiz
    @quiz = ActiveQuiz.find_by(pin: params[:pin]) 
  end


end
