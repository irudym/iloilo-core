FactoryBot.define do
  factory :quiz_response do
    question
    user
    answers { build_list :answers, 3 }
  end
end