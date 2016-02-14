FactoryGirl.define do
  factory :team do
    organization
    name { Faker::Company.name }
    admin false
  end
end
