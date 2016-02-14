FactoryGirl.define do
  factory :project do
    organization
    name { Faker::Company.name }

    after(:build, &:generate_metrics_token)
  end
end
