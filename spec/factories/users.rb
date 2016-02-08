FactoryGirl.define do
  factory :user do
    # first_name                  { Faker::Name.first_name }
    # last_name                   { Faker::Name.last_name }
    password { Faker::Internet.password(8) }
    email    { Faker::Internet.email }
  end
end
