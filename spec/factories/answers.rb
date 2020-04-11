FactoryBot.define do
  factory :answer do
    text { Faker::Movies::StarWars.quote }
    question
  end
end