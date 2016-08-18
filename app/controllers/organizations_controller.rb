class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  include OrganizationsHelper

  def index
    @organizations = policy_scope(Organization)
  end

  def new
    @organization = Organization.new
    authorize organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize organization
    organization.build_team(current_user)
    if organization.save
      redirect_to_edit_organization(:success, t('organizations.create.success'))
    else
      render 'new'
    end
  end

  def edit
    organization
    authorize organization
    @teams = organization.teams.includes(:users)
  end

  def update
    authorize organization
    if organization.update(organization_params)
      redirect_to_edit_organization(:success, t('organizations.update.success'))
    else
      render 'edit'
    end
  end

  def destroy
    authorize organization
    if organization.destroy
      redirect_to organizations_path, flash: { success: t('organizations.destroy.success') }
    else
      render 'edit'
    end
  end

  private

  def organization
    @organization ||= Organization.friendly.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(
      :name, :github_name, :github_url, :github_avatar_url, :bot_access_token
    )
  end
end
