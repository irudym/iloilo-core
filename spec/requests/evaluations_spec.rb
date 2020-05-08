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

      describe 'GET /evaluations/:PIN/quiz' do
        before { get "/#{controller}/#{started_quiz_pin}/quiz", params: {}, headers: headers }

        it 'returns active quiz object with relationships - one quesiton by random' do
          expect(json['data']['relationships']).not_to be_empty
          expect(json['data']['relationships']['questions']['data'].length).to eq(1)
        end
      end

      describe 'POST /evaluations/:PIN/quiz' do 
        let(:valid_attributes) {
          {
            data: {
              type: 'evaluation',
              attributes: {
                pin: started_active_quiz.pin
              },
              relationships: {
                questions: {
                  data: [
                    {
                      type: 'question',
                      id: started_active_quiz.quiz.questions.first.id,
                      relationships: {
                        answers: {
                          data: [
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.first.id,
                              attributes: {
                                correct: true
                              }
                            },
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.second.id,
                              attributes: {
                                correct: true
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
          }.to_json
        }
        before { post "/#{controller}/#{started_quiz_pin}/quiz", params: valid_attributes, headers: headers }

        it 'accepts the evaluation with status 201' do
          expect(response).to have_http_status(200)
        end

        it 'returns the next question with answers included' do 
          # puts "LOG[Evaluation_Spec]: response: #{json}"
          expect(json['data']['attributes']['text']).not_to be_empty
          expect(json['included']).not_to be_empty
        end
      end

      describe 'when an user POST response with no provided answers (with correct field)' do 
        let(:invalid_attributes) {
          {
            data: {
              type: 'evaluation',
              attributes: {
                pin: started_active_quiz.pin
              },
              relationships: {
                questions: {
                  data: [
                    {
                      type: 'question',
                      id: started_active_quiz.quiz.questions.first.id,
                      relationships: {
                        answers: {
                          data: [
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.first.id,
                            },
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.second.id,
                              attributes: {
                                correct: false
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
          }.to_json
        }
        before { post "/#{controller}/#{started_quiz_pin}/quiz", params: invalid_attributes, headers: headers }

        it 'response with error' do
          expect(json['errors'][0]['detail']).to match(/At least one answer should be selected/)
        end
      end

      describe 'when submit the answers on the same questions twise' do
        let(:valid_attributes) {
          {
            data: {
              type: 'evaluation',
              attributes: {
                pin: started_active_quiz.pin
              },
              relationships: {
                questions: {
                  data: [
                    {
                      type: 'question',
                      id: started_active_quiz.quiz.questions.first.id,
                      relationships: {
                        answers: {
                          data: [
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.first.id,
                              attributes: {
                                correct: true,
                              }
                            },
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.second.id,
                              attributes: {
                                correct: false
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
          }.to_json
        }
        before {
          post "/#{controller}/#{started_quiz_pin}/quiz", params: valid_attributes, headers: headers
          post "/#{controller}/#{started_quiz_pin}/quiz", params: valid_attributes, headers: headers
        }
        it "doesn't count provided answers and still provide a next question" do
          expect(json['data']['type']).to eq('question')
        end
      end

      describe 'when submit the answer after time ends' do
        let(:valid_attributes) {
          {
            data: {
              type: 'evaluation',
              attributes: {
                pin: started_active_quiz.pin
              },
              relationships: {
                questions: {
                  data: [
                    {
                      type: 'question',
                      id: started_active_quiz.quiz.questions.first.id,
                      relationships: {
                        answers: {
                          data: [
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.first.id,
                              attributes: {
                                correct: true
                              }
                            },
                            {
                              type: 'answer',
                              id: started_active_quiz.quiz.questions.first.answers.second.id,
                              attributes: {
                                correct: true
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
          }.to_json
        }
        let(:ended_active_quiz) { create(:started_quiz, ended_at: DateTime.current - 200.minutes) }
        before { post "/#{controller}/#{ended_active_quiz.pin}/quiz", params: valid_attributes, headers: headers }

        it 'returns immidiate result' do
          expect(json['data']['type']).to eq('evaluation')
        end
      end
    end
  end

end