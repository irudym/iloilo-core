require 'rails_helper'

RSpec.describe ActiveQuiz, type: :model do
  describe 'Evaluation user score' do
    before {
        # create test records
        @quiz = create(:quiz, max_score: 100)
        @user = create(:user)
        question1 = create(:question, quiz: @quiz)
        answer1 = create(:answer, question: question1, correct: true)
        answer2 = create(:answer, question: question1, correct: true)
        answer3 = create(:answer, question: question1)

        question2 = create(:question, quiz: @quiz)
        answer4 = create(:answer, question: question2)
        answer5 = create(:answer, question: question2, correct: true)

        question3 = create(:question, quiz: @quiz)
        answer6 = create(:answer, question: question3, correct: true)
        answer7 = create(:answer, question: question3)

        @active_quiz = create(:active_quiz, quiz: @quiz)

        @quiz_response1 = create(:quiz_response, 
          active_quiz: @active_quiz, user: @user, question: question1, answers: [answer1, answer3], score: 0)
        @quiz_response1 = create(:quiz_response, 
          active_quiz: @active_quiz, user: @user, question: question2, answers: [answer5], score: 1)
        @quiz_response1 = create(:quiz_response, 
          active_quiz: @active_quiz, user: @user, question: question3, answers: [answer6], score: 1)  
      }


    it "calculates the user's score based on the result and max_score attribute" do
      score = @active_quiz.user_score(@user)
      expect(score).to eq(66)
    end
  end
end
