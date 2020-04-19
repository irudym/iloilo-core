FactoryBot.define do
  factory :group do
    name { Faker::Movies::StarWars.character }
    description { Faker::Movies::StarWars.quote }
  end

  factory :group_with_users, parent: :group do
    users { build_list :user, 4}
  end
end