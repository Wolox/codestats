require 'rails_helper'

describe ProjectPolicy do
  let(:user) { create(:user) }
  subject { described_class }

  permissions :show? do
    context 'When user is not part of a project team' do
      let!(:project) { create(:project) }
      it 'Denies access to the project show' do
        expect(subject).not_to permit(user, project)
      end
    end

    context 'When user is part of a project team' do
      let!(:project) { create(:project) }
      let!(:team) do
        create(
          :team,
          projects: [project],
          organization: project.organization,
          users: [user]
        )
      end
      it 'Allows access to the project show' do
        expect(subject).to permit(user, project)
      end
    end
  end
end
