require 'rails_helper'

RSpec.describe Question, type: :model do
  it {
    should validate_presence_of(:text)
  }

  describe 'Destroying quiestion from Quiz with method destroy_with_answers' do
    let!(:quizzes) { create_list(:quiz_with_questions, 5) }
    let(:quiz) { quizzes.first }
    let!(:active_quiz) { create(:started_quiz) }
    let(:question) { active_quiz.quiz.questions.first} 

    context 'Quiz was not activated and quiesiton was not answered' do
      let!(:question) { quiz.questions.first }
      before { question.destroy_with_answers }

      it 'deletes the question and related answers' do
        expect(Question.where(id: question.id)).to be_empty
      end
    end

    context 'Quiz was activated' do
      let!(:question) { active_quiz.quiz.questions.first} 

      it 'deletes the question and related answers' do
        expect { question.destroy_with_answers }.not_to raise_error
      end
    end

    context 'Quiz was activated and the question was answered' do
      let!(:question) { active_quiz.quiz.questions.second} 
      let!(:quiz_response) { create(:quiz_response, question: question,active_quiz: active_quiz)}
      before { question.destroy_with_answers }

      it 'delete quiz_id record from the quiz questions' do
        expect(active_quiz.quiz.questions.where(id: question.id)).to be_empty
      end

      it 'delete quiz_id record from the quiz questions, however keeps the question' do
        expect(Question.where(id: question.id)).not_to be_empty
      end

    end
  end
end
