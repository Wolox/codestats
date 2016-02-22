class OrganizationsController < ApplicationController
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
    organization.teams.build(name: 'Admins', admin: true, users: [current_user])
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

  def link_to_github
    authorize organization, :update?
    organization
    # TODO: this should be done over ajax so the user does not notice the delay
    @github_orgs = github_service.get_organizations(per_page: 400)
    @github_orgs.select! { |o| !existing_organizations.include?(o.login) }
  end

  def unlink_github
    authorize organization, :update?
    if organization.update(github_url: nil, github_avatar_url: nil, github_name: nil)
      redirect_to_edit_organization(:success, t('organizations.unlink.success'))
    else
      render 'edit'
    end
  end

  def update
    authorize organization
    if organization.update(organization_params)
      redirect_to_edit_organization(:success, t('organizations.update.success'))
    else
      render 'edit'
    end
  end

  private

  def redirect_to_edit_organization(type_message, message)
    redirect_to edit_organization_path(organization), flash: { type_message => message }
  end

  def github_service
    GithubService.new(current_user)
  end

  def existing_organizations
    # TODO: Add teams here
    @existing ||= current_user.organizations.pluck(:github_name)
  end

  def organization
    @organization ||= Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :github_name, :github_url, :github_avatar_url)
  end
end
