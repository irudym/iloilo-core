FactoryBot.define do
  factory :active_quiz do
    pin { Faker::Name.first_name }
    quiz { create(:quiz_with_questions) }
    user
    duration { 10 }
  end

  factory :started_quiz, parent: :active_quiz do
    started { true }
  end
end