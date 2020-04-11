# Request to Evaluations Controller
require 'rails_helper'

controller = 'evaluations'

RSpec.describe 'Evaluations API', type: :request do
  let(:user) { create(:user) }
  
  # authorize request
  let(:headers) {
    custom_valid_headers(user)
  }

  let(:active_quizzes) { create_list(:active_quiz, 5) }
  let(:started_active_quiz) { create(:started_quiz) }
  let(:quiz_pin) { active_quizzes.first.pin}
  let(:started_quiz_pin) { started_active_quiz.pin}

  context 'Non admin user' do
    context 'when PIN is valid' do
      describe 'GET /evaluations/:PIN' do
        before { get "/#{controller}/#{quiz_pin}", params: {}, headers: headers }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns information about the quiz' do
          expect(json['data']['attributes']['pin']).to eq(quiz_pin)
        end
      end

      describe ' GET/evaluations/:PIN/quiz' do
        before { get "/#{controller}/#{started_quiz_pin}/quiz", params: {}, headers: headers }

        it 'returns array of questions with answers' do
          puts "==>LOG[EvaluationsSpec]: response: #{json}"
          expect(json['data']['attributes']['questions']).not_to be_empty
        end
      end
    end
  end

end