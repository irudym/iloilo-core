FactoryBot.define do
  factory :quiz do
    title { Faker::Movies::StarWars.character }
    description { Faker::Movies::StarWars.quote }
  end

  factory :quiz_with_questions, parent: :quiz do
    questions { build_list :question_with_answers, 4}
  end
end