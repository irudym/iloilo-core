require 'rails_helper'

RSpec.describe QuizResponse, type: :model do
  describe 'create_with_questions method' do
    before {
        # create test records
        @quiz = create(:quiz)
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

        @user_answers = [
          {
            type: 'question',
            id: question1.id,
            relationships: {
              answers: { data: [
                {
                  type: 'answer',
                  id: answer1.id,
                  attributes: { correct: false }
                },
                {
                  type: 'answer',
                  id: answer2.id,
                  attributes: { correct: true }
                },
                {
                  type: 'answer',
                  id: answer3.id,
                  attributes: { correct: true }
                } 
              ]}
            }
          },
          {
            type: 'question',
            id: question2.id,
            relationships: {}
          },
          {
            type: 'question',
            id: question3.id,
            relationships: {
              answers: { data: [
                {
                  type: 'answer',
                  id: answer6.id,
                  attributes: { correct: true }
                },
              ]}
            }
          }
        ]
      }

    it 'create records with answers where answers are correct' do
      # response = QuizResponse.create_with_questions(user: @user, quiz: @active_quiz, questions: @user_answers)
    end

  end
end
