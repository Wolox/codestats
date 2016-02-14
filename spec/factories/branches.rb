FactoryGirl.define do
  factory :branch do
    project
    name { Faker::Name.name }
    default false
  end
end
