require 'rails_helper'

describe Organization do
  it { should validate_presence_of(:name) }

  subject(:organization) { Organization.new(name: name) }

  let(:name) { Faker::Company.name }

  it { is_expected.to be_valid }

  describe '#admin_team' do
    context 'When it has an admin team' do
      let!(:team) { create(:team, organization: organization, admin: true) }

      it 'returns the admin team' do
        expect(organization.admin_team).to eq team
      end
    end
    context 'When it has more than one admin team' do
      let!(:first_admin_team) { create(:team, organization: organization, admin: true) }
      let!(:second_admin_team) { create(:team, organization: organization, admin: true) }

      it 'returns the first created admin team' do
        expect(organization.admin_team).to eq first_admin_team
      end
    end
    context 'When it does\'t have an admin team' do
      it 'returns nil' do
        expect(organization.admin_team).to eq nil
      end
    end
  end

  describe '#admin_team?' do
    context 'When checking for the correct admin team' do
      let!(:team) { create(:team, organization: organization, admin: true) }

      it 'returns true' do
        expect(organization.admin_team?(team)).to be true
      end
    end
    context 'When checking for the incorrect admin team' do
      let!(:non_admin_team) { create(:team, organization: organization) }
      it 'returns false' do
        expect(organization.admin_team?(non_admin_team)).to be false
      end
    end
  end

  describe '#admin_user' do
    context 'When it has a user in the admin team' do
      let!(:team_user) { create(:user) }
      let!(:admin_team) do
        create(:team, organization: organization, admin: true, users: [team_user])
      end

      it 'returns the first user of the admin team' do
        expect(organization.admin_user).to eq team_user
      end
    end
    context 'When it doesn\'t have a user in the admin team' do
      let!(:admin_team) { create(:team, organization: organization, admin: true) }
      it 'returns nil' do
        expect(organization.admin_user).to be nil
      end
    end
    context 'When it doesn\'t have an admin team' do
      it 'returns nil' do
        expect(organization.admin_user).to be nil
      end
    end
  end

  describe '#build_team' do
    let!(:user) { create(:user) }
    context 'When building the admin team' do
      it { expect(organization.build_team(user)).to be_valid }

      it 'assigns the user to the admin team' do
        team = organization.build_team(user)
        expect(team.users).to include(user)
      end
    end
  end
end
