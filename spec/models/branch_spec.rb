require 'rails_helper'

describe Branch do
  it { should validate_presence_of(:name) }
  subject(:branch) { Branch.new(project: project, name: name) }

  let(:name) { Faker::Name.name }
  let(:project) { create(:project) }

  it { is_expected.to be_valid }

  describe '#create' do
    context 'When another branch with the same name exists' do
      let!(:another_branch) { create(:branch, project: project, name: name) }

      it { is_expected.not_to be_valid }
    end
  end
end
