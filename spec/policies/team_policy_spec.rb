require 'rails_helper'

describe TeamPolicy do
  let(:user) { create(:user) }
  subject { described_class }

  permissions :create?, :update?, :destroy?, :edit?, :new? do
    context 'When user is not part of an organization admin team' do
      let!(:team) { create(:team, users: [user]) }
      it 'Denies access to the project show' do
        expect(subject).not_to permit(user, team)
      end
    end

    context 'When user is part of a project team' do
      let!(:team) { create(:admin_team, users: [user]) }
      it 'Allows access to the project show' do
        expect(subject).to permit(user, team)
      end
    end
  end
end
