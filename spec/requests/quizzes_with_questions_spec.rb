require 'rails_helper'

controller = 'quizzes'

RSpec.describe 'Quizzes API: working with relationships', type: :request do
  context 'Admin user requests' do
    let(:user) { create(:user) }
    let(:admin_user) { create(:admin_user) }

    # authorize request
    let(:headers) {
      custom_valid_headers(admin_user)
    }

    describe 'Post a quiz with questions (with answers)' do
      let(:attributes_with_questions) { { 
        data: {
          type: 'quiz',
          attributes: {
            title: 'Simple Quiz',
            description: 'Just a simple quiz to test Quiz Controlle'
          },
          relationships: {
            questions: {
              data: [
                {
                  type: 'question',
                  attributes: {
                    text: 'Question 1'
                  },
                  relationships: {
                    answers: {
                      data: [
                        {
                          type: 'answer',
                          attributes: {
                            text: 'Answer 1',
                            correct: true,
                          }
                        },
                        {
                          type: 'answer',
                          attributes: {
                            text: 'Answer 2',
                            correct: false,
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            }
          }
        }
      }.to_json}

      context 'when the request is valid' do
        before { post "/#{controller}", params: attributes_with_questions, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'creates a quiz resource with questions and answers' do
          expect(json['data']['relationships']['questions']).not_to be_nil
          expect(json['data']['relationships']['questions']['data']).not_to be_empty
        end
      end
    end
  end
end