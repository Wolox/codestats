FactoryGirl.define do
  factory :team do
    organization
    name { Faker::Company.name }
    admin false
  end

  factory :admin_team, class: Team do
    organization
    name { Faker::Company.name }
    admin true
  end
end
