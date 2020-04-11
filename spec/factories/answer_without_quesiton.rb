FactoryBot.define do
  factory :answer_without_question, parent: :answer do
    text { Faker::Movies::StarWars.quote }
  end
end