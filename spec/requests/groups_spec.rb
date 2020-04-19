# Request to Quizzes Controller
require 'rails_helper'

controller = 'groups'

RSpec.describe 'Groups API', type: :request do
  let!(:groups) { create_list(:group_with_users, 5) }
  
  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user_with_quiz) }


  # authorize request
  let(:headers) {
    custom_valid_headers(admin_user)
  }

  context 'Admin user' do
    describe 'GET /groups' do
      # make HTTP get request before each test
      before { get "/#{controller}", params: {},  headers: headers }

      it 'returns list of quizzes' do
       expect(json).not_to be_empty
     end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a list of groups' do 
        expect(json).not_to be_empty
      end

      it 'provide information about how many users in the group' do 
        expect(json['data'][0]['attributes']['user_count']).to eq(4)
      end
    end
  end
end