FactoryBot.define do
  factory :quiz_response do
    question
    user
    answers { build_list :answer, 3 }
  end
end