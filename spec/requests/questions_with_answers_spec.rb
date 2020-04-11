require 'rails_helper'

controller = 'questions'

RSpec.describe 'Questions API: working with relationships', type: :request do
  let!(:questions) { create_list(:question, 5) }
  let(:question_id) { questions.first.id }
  let!(:quizzes) { create_list(:quiz, 1) }

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user_with_quiz) }

  # authorize request
  let(:headers) {
    custom_valid_headers(admin_user)
  }
  let(:quiz_id) { admin_user.quizzes.first.id }
  
  context 'Admin user requests' do
    describe 'POST question with answers' do 
      let(:attributes_with_answers) { {
        data: {
          type: "question", attributes: { text: 'How much is 2*2?' },
          relationships: {
            quiz: { data: { type: "quiz", id: quiz_id} },
            answers: {
              data: [
                {
                  type: "answer",
                  attributes: { text: "2" }
                },
                {
                  type: "answer",
                  attributes: { text: "6" }
                }
              ]
            }
          }
        }
      }.to_json }

      context 'when the request is valid' do
        before { post "/#{controller}", params: attributes_with_answers, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'creates a question resource with answers' do
          expect(json['data']['relationships']['answers']).not_to be_nil
          expect(json['data']['relationships']['answers']['data']).not_to be_empty
        end
      end

      context 'when the request is invalid, type mistmatch in answers object' do
        let(:attributes_without_answers) { {
          data: {
            type: "question", attributes: { text: 'How much is 2*2?' },
            relationships: {
              quiz: { data: { type: "quiz", id: quiz_id} },
              answers: {
                data: [
                  {
                    type: "response",
                    attributes: { text: "2" }
                  },
                  {
                    type: "response",
                    attributes: { text: "6" }
                  }
                ]
              }
            }
          }
        }.to_json }
        before { post "/#{controller}", params: attributes_without_answers, headers: headers }

        it 'creates a question resource but without answers' do
          expect(json['data']['relationships']['answers']['data']).to be_empty
        end
      end
    end

    describe 'POST question with answers and right answers' do
      let(:attributes_with_right_answers) { {
        data: {
          type: "question", attributes: { text: 'How much is 2*2?' },
          relationships: {
            quiz: { data: { type: "quiz", id: quiz_id} },
            answers: {
              data: [
                {
                  type: "answer",
                  attributes: { text: "4", correct: true }
                },
                {
                  type: "answer",
                  attributes: { text: "6" }
                },
                {
                  type: "answer",
                  attributes: { text: "10"}
                }
              ]
            }
          }
        }
      }.to_json }

      context 'when the request is valid' do
        before { post "/#{controller}", params: attributes_with_right_answers, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

    end 

    describe 'PUT /questions/:id' do
      describe 'Update question with answer'
      let(:question) { create(:question_with_answers) }
      
      let(:attributes_with_answers) {{
        data: {
          id: question.id,
          type: "question", attributes: { text: 'How much is 2*2?' },
          relationships: {
            answers: {
              data: [
                {
                  type: "answer",
                  id: question.answers[0][:id],
                  attributes: { text: "updated answer" }
                },
                {
                  type: 'answer',
                  id: question.answers[1][:id],
                  attributes: { text: 'another updated answer' }
                },
                {
                  type: "answer",
                  attributes: { text: "additional answer", correct: true }
                }
              ]
            }
          }
        }
      }.to_json}

      context 'when the request is valid' do
        before { put "/#{controller}/#{question_id}", params: attributes_with_answers, headers: headers }

        it 'returns status code 404' do
          # as the question doesn't belong to admin user's quizzes
          expect(response).to have_http_status(404)
        end

#        it 'updates the question with answers' do
#          expect(json['data']['relationships']['answers']).not_to be_nil
#        end
      end
    end
  end
end