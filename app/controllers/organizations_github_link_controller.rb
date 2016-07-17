class OrganizationsGithubLinkController < ApplicationController
  before_action :authenticate_user!
  include OrganizationsHelper

  def new
    authorize organization, :update?
    organization
    # TODO: this should be done over ajax so the user does not notice the delay
    @github_orgs = github_service.get_organizations(per_page: 400)
    @github_orgs.select! { |o| !existing_organizations.include?(o.login) }
  end

  def create
    authorize organization, :update?
    if organization.update(github_link_params)
      redirect_to_edit_organization(:success, t('organizations.update.success'))
    else
      render 'new'
    end
  end

  def unlink
    authorize organization, :update?
    if organization.update(github_url: nil, github_avatar_url: nil, github_name: nil)
      redirect_to_edit_organization(:success, t('organizations.unlink.success'))
    else
      render 'edit'
    end
  end

  private

  def existing_organizations
    @existing ||= current_user.organizations.pluck(:github_name)
  end

  def github_service
    GithubService.new(current_user)
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end

  def github_link_params
    params.require(:github_link).permit(:github_name, :github_avatar_url, :github_url)
  end
end
