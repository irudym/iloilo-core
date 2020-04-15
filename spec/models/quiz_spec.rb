require 'rails_helper'

RSpec.describe Quiz, type: :model do
  it {
    should validate_presence_of(:title)
  }

  describe "User's answers scoring" do

    before {
      # create test records
      @quiz = create(:quiz)
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



    it "evaluates user's provided answers and count the score" do
      score = @quiz.evaluate(@user_answers)
      expect(score).to eq(33)
    end

  end
end
