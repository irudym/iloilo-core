require 'rails_helper'

controller = 'answers'

RSpec.describe 'Answers API', type: :request do
  let!(:answers) { create_list(:answer, 5) }
  let(:answer_id) { answers.first.id }
  
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  # authorize request
  let(:headers) {
    custom_valid_headers(admin_user)
  }


  context 'Admin user' do

    describe 'GET /answers' do
       # make HTTP get request before each test
       before { get "/#{controller}", params: {}, headers: headers }

       it 'returns list of questions' do
        expect(json).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET /answers/:id' do 
      before { get "/#{controller}/#{answer_id}", params: {}, headers: headers }

      context 'when the record exists' do
        it 'returns the record' do
          expect(json).not_to be_empty
          expect(json['data']['id'].to_i).to eq(answer_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

    end
  end
end