require 'rails_helper'

describe OrganizationPolicy do
  let(:user) { create(:user) }
  subject { described_class }

  permissions :update?, :edit? do
    context 'When user is not part of the admin team' do
      let(:organization) { create(:organization) }
      it 'Denies access to the organization edition' do
        expect(subject).not_to permit(user, organization)
      end
    end

    context 'When user is part of the admin team' do
      let(:team) { create(:team, admin: true, users: [user]) }
      it 'Allows access to the organization edition' do
        expect(subject).to permit(user, team.organization)
      end
    end
  end

  permissions :create?, :new? do
    context 'When the user is present' do
      let(:organization) { build(:organization) }
      it 'Allows access to the organization creation' do
        expect(subject).to permit(user, organization)
      end
    end
  end
end
