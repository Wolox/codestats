require 'rails_helper'

describe Project do
  subject(:project) do
    Project.new(organization: organization, teams: [team], metrics_token: metrics_token)
  end

  let(:name) { Faker::Company.name }
  let(:admin) { true }
  let(:organization) { create(:organization) }
  let(:metrics_token) { nil }
  let(:team) { create(:team, organization: organization) }

  it { is_expected.to be_valid }

  describe '#default_branch' do
    context 'When it has a default branch' do
      let!(:default_branch) { create(:branch, project: project, default: true) }
      it 'returns the default branch' do
        expect(project.default_branch).to eq default_branch
      end
    end
    context 'When it doesn\'t have a default branch' do
      it 'returns nil' do
        expect(project.default_branch).to be nil
      end
    end
    context 'When it doesn\'t have branches' do
      it 'returns nil' do
        expect(project.default_branch).to be nil
      end
    end
  end
  describe '#default_branch_metrics' do
    context 'When it has a default branch' do
      let(:metric) { create(:metric) }
      let!(:default_branch) { create(:branch, project: project, default: true, metrics: [metric]) }
      it 'returns the metrics ' do
        expect(project.default_branch_metrics).to eq [metric]
      end
    end
    context 'When it doesn\'t have a default branch' do
      it 'returns empty array' do
        expect(project.default_branch_metrics).to eq []
      end
    end
  end
  describe '#generate_metrics_token' do
    before do
      project.generate_metrics_token
    end
    context 'When generating the token to create new metrics' do
      it 'assigns a metrics token' do
        expect(project.metrics_token).not_to be nil
      end
    end
    context 'When generating a new token to create new metrics' do
      let(:metrics_token) { Faker::Number.number(10).to_s }

      it 'assigns a new metrics token' do
        expect(project.metrics_token).not_to eq metrics_token
      end
    end
  end
end
