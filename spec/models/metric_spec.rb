require 'rails_helper'

describe Metric do
  it { should validate_presence_of(:name) }

  subject(:user) { Metric.new(name: name, branch: branch, value: value) }

  let(:name) { Faker::Company.name }
  let(:value) { Faker::Number.decimal(2) }
  let(:branch) { create(:branch) }

  it { is_expected.to be_valid }
end
