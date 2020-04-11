FactoryBot.define do
  factory :question_with_answers, parent: :question do |question|
    answers { build_list :answer_without_question, 3 }
  end
end