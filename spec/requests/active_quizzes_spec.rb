require 'rails_helper'

controller = 'active_quizzes'

RSpec.describe 'Active Quizzes API', type: :request do
  let!(:quizzes) { create_list(:quiz, 5) }
  

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user_with_active_quiz) }
  let(:quiz_id) { admin_user.quizzes.first.id }
  let(:non_user_quiz_id) { quizzes.first.id}

  # authorize request
  let(:headers) {
    custom_valid_headers(admin_user)
  }


  context 'Admin user' do
    describe 'POST /active_quizzes' do
      context 'when the params are valid and quiz is not active' do
        # make HTTP get request before each test
        before { post "/#{controller}", params: {data: { relationships: { quiz_id: quiz_id} } }.to_json, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201) 
        end

        it 'activates provided quiz and return PIN' do
          expect(json['data']['attributes']['pin']).not_to be_nil
        end
      end
    end

    describe 'PUT /active_quizzes/:id' do
      context 'when no params provided' do
        let(:active_quiz) { admin_user.active_quizzes.first } 
        before { put "/#{controller}/#{active_quiz.id}", params: {data: {}}.to_json, headers: headers }

        it 'starts the quiz' do 
          expect(json['data']['attributes']['started']).to be_truthy
        end 
      end

      context 'when duration is overrided' do
        let(:active_quiz) { admin_user.active_quizzes.first } 
        before { put "/#{controller}/#{active_quiz.id}", params: { data: { attributes: { duration: 123 }}}.to_json, headers: headers }

        it 'starts the quiz' do 
          expect(json['data']['attributes']['duration']).to be_eql(123)
        end 
      end

      context 'when comment provided' do
        let(:active_quiz) { admin_user.active_quizzes.first }
        before { put "/#{controller}/#{active_quiz.id}", params: {data: { attributes: { comment: 'Just a comment'}}}.to_json, headers: headers } 

        it 'starts the quiz and update the comment' do
          expect(json['data']['attributes']['comment']).to be_eql('Just a comment')
        end
      end
      
    end


    describe "tries to activate quiz which does't belong to the admin user" do
      # create quiz for the admin user
      before { post "/quizzes", params: { data: { attributes: { title: "test"}, relationships: { user_id: admin_user.id }}}.to_json, 
        headers: headers } 
      before { post "/#{controller}", params: {data: { relationships: { quiz_id: non_user_quiz_id} } }.to_json, headers: headers }

      it 'returns error with status 404' do
        expect(response).to have_http_status(404)
      end

    end

  end
end