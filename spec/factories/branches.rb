FactoryGirl.define do
  factory :branch do
    project create(:project)
    name { Faker::Name.name }
    default false
  end
end
