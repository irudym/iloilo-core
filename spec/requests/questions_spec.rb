# Request to Questions Controller
require 'rails_helper'

controller = 'questions'

RSpec.describe 'Questions API', type: :request do
  let!(:questions) { create_list(:question, 5) }
  let(:question_id) { questions.first.id }

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user_with_quiz) }

  # authorize request
  let(:headers) {
    custom_valid_headers(admin_user)
  }


  context 'Non admin' do

    describe 'GET /questions' do
       # make HTTP get request before each test
       before { get "/#{controller}", params: {}, headers: {} }

#       it 'returns list of questions' do
#        expect(json).not_to be_empty
#      end

      it 'returns status code 422' do
        # as only admin have access to their questions  
        expect(response).to have_http_status(422)
      end
    end

    describe 'GET /questions/:id' do 
      before { get "/#{controller}/#{question_id}", params: {}, headers: {} }

      context 'when the record exists' do
#        it 'returns the record' do
#          expect(json).not_to be_empty
#          expect(json['data']['id'].to_i).to eq(question_id)
#        end

        it 'returns status code 422' do
          # as only admin have access to their questions  
          expect(response).to have_http_status(422)
        end
      end

    end
  end

  context 'Admin user' do
    let!(:quizzes) { create_list(:quiz, 5) }
    let(:quiz_id) { admin_user.quizzes.first.id }
    
    describe 'POST /questions' do
      # valid payload
      let(:valid_attributes) { { 
        data: { 
          type: 'question', attributes: { text: 'How big is an elephant?' },
          relationships: { 
            quiz: { data: { type: "quiz", id: quiz_id} }  
          } 
        } 
      }.to_json }

      let(:invalid_attributes_quiz_id) { { 
        data: {
          type: 'questions', attributes: { text: 'How big is an elephant?' },
          relationships: {
            quiz: { data: { type: 'quiz', id: -1 } }
          }
        }
      }.to_json }

      let(:invalid_attributes_text) { { 
        data: {
          type: 'questions', attributes: { },
          relationships: {
            quiz: { data: { type: 'quiz', id: quiz_id } }
          }
        }
      }.to_json }

      context 'when the request is valid and quiz belong to admin user ' do
        before { post "/#{controller}", params: valid_attributes, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'creates a question object' do
          expect(json['data']['attributes']['text']).to eq('How big is an elephant?')
        end
      end

      context 'when the request is invalid' do

        context 'provided a wrong quiz ID' do
          before { post "/#{controller}", params: invalid_attributes_quiz_id, headers: headers }
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns error message' do
            expect(json['errors'][0]['detail']).to match(/Couldn't find Quiz with/)
          end
        end

        context 'missed text field' do
          before { post "/#{controller}", params: invalid_attributes_text, headers: headers }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns error validation message' do
            expect(json['errors'][0]['detail']).to match(/param is missing or the value is empty/)
          end
        end
      end
    end

  end
end