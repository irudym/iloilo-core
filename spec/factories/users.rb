FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'foobar' }
  end

  factory :admin_user, class: 'User' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'foobar' }

    after :create do |user|
      create :admin, user: user
    end
  end

  factory :admin_user_with_quiz, class: 'User' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'foobar' }

    after :create do |user|
      create :admin, user: user
      create :quiz, user: user
    end
  end

  factory :admin_user_with_active_quiz, class: 'User' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'foobar' }

    after :create do |user|
      create :admin, user: user
      create :quiz, user: user
      create :started_quiz, user: user
    end
  end
end