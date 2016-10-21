require 'rails_helper'

describe Team do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:organization) }

  subject(:team) { Team.new(name: name, organization: organization, admin: admin) }

  let(:name) { Faker::Company.name }
  let(:admin) { true }
  let(:organization) { create(:organization) }

  it { is_expected.to be_valid }

  describe '#includes_project?' do
    context 'When it has the project' do
      let(:team_project) { create(:project, organization: organization, teams: [team]) }
      it 'returns true' do
        expect(team.includes_project?(team_project)).to be true
      end
    end
    context 'When it has no projects' do
      let(:project) { create(:project, organization: organization, teams: [create(:team)]) }
      it 'returns false' do
        expect(team.includes_project?(project)).to be false
      end
    end
  end
end
