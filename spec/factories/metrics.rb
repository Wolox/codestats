FactoryGirl.define do
  factory :metric do
    branch
    name { Faker::Name.name }
    value { Faker::Number.decimal(2) }
  end
end
