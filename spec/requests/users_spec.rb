require 'rails_helper'

controller = 'users'

RSpec.describe 'Users API', type: :request do
  context "non logged-in user sign-up" do
    describe "User signup with valid attributes" do
      let(:valid_attributes) { {data: {
        attributes: {
          email: "Test@email.Com",
          password: "password",
          first_name: "John",
          last_name: "Doe",
        }
      }}}

      before { post "/signup", xhr:true, params: valid_attributes }
      

      it 'creates an user with status 201' do
        expect(response).to have_http_status(201)
      end

      it 'downcases email' do
        expect(json['email']).to eq('test@email.com')
      end
    end

    describe "User singup with wron email format" do
      let(:invalid_attributes) { { data: {
        attributes: {
          email: "Test#email",
          password: "password",
          first_name: "John",
          last_name: "Doe"
        }
      } } }
      before { post '/signup', xhr:true, params: invalid_attributes }

      it 'returns error' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json["errors"][0]["detail"]).to match(/Validation failed: Email is invalid/)
      end
    end
  end

end