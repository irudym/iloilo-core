# Request to Quizzes Controller
require 'rails_helper'

controller = 'quizzes'

RSpec.describe 'Quizzes API', type: :request do
  let!(:quizzes) { create_list(:quiz, 5) }
  
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user_with_quiz) }
  let(:quiz_id) { admin_user.quizzes.first.id }

  # authorize request
  let(:headers) {
    custom_valid_headers(admin_user)
  }

  context 'Admin user' do
    describe 'GET /quizzes' do
       # make HTTP get request before each test
       before { get "/#{controller}", params: {},  headers: headers }

       it 'returns list of quizzes' do
        expect(json).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET /quizzes/:id' do 
      before { get "/#{controller}/#{quiz_id}", params: {},  headers: headers }

      context 'when the record exists' do
        it 'returns the record' do
          expect(json).not_to be_empty
          expect(json['data']['id'].to_i).to eq(quiz_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

    end

    # Test suit for POST actions
    describe 'POST /quizzes' do
      # valid payload
      let(:valid_attributes) { { data: { 
        type: 'quiz', attributes: {
          title: 'Simple quiz', description: 'Just a simple quiz for test purposes'
        } } }.to_json }

      context 'when the request is valid' do
        before { post "/#{controller}", params: valid_attributes,  headers: headers }
        
        it 'create a quiz record' do
          expect(json['data']['attributes']['title']).to eq('Simple quiz')
        end

        it 'returns status 201' do
          expect(response).to have_http_status(201) 
        end
      end

      context 'when the request is invalid - wrong data format' do
        before { post "/#{controller}", params: {description: 'brand'}.to_json,  headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(json['errors'][0]['detail']).to match(/param is missing or the value is empty/)
        end
      end

      context 'when the request is invalid - not all required attributes provided' do
        before { post "/#{controller}", params: { 'data': { 'attributes': { 'description': "just a quiz" } } }.to_json,  headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(json['errors'][0]['detail']).to match(/Validation failed: Title can't be blank/)
        end
      end

    end
  end
end