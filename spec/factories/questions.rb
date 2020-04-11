FactoryBot.define do
  factory :question do
    text { Faker::Movies::StarWars.quote }
    quiz
  end
end