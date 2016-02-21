require 'rails_helper'

RSpec.describe OrganizationsController do
  include_context 'Authorized User Shared Context'
  describe 'GET edit' do
    context 'When editing an organization' do
      let!(:organization) { create(:organization) }
      let!(:team)         { create(:admin_team, organization: organization, users: [user]) }
      before(:each) do
        get :edit, id: organization.id
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'assigns the current user organization to @organization' do
        expect(assigns(:organization)).to eq(organization)
      end
    end
  end

  describe 'PATCH update' do
    context 'When updating an organization correctly' do
      let!(:organization) { create(:organization) }
      let!(:team)         { create(:admin_team, organization: organization, users: [user]) }
      let(:new_name)      { "#{organization}-new" }

      before(:each) do
        patch :update, id: organization.id, organization: { name: new_name }
      end

      it 'updates the organization name' do
        organization.reload
        expect(organization.name).to eq(new_name)
      end

      it 'redirects back to the edit path' do
        expect(response).to redirect_to edit_organization_path(organization)
      end
    end

    context 'When updating an organization with error' do
      let!(:organization) { create(:organization) }
      let!(:team)         { create(:admin_team, organization: organization, users: [user]) }
      let(:new_name)      { nil }

      before(:each) do
        patch :update, id: organization.id, organization: { name: new_name }
      end

      it 'doesn\'t update the organization name' do
        organization.reload
        expect(organization.name).to eq(organization.name)
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end
end
