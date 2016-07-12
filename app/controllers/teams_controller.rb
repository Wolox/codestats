class TeamsController < ApplicationController
  before_action :authenticate_user!
  # Preload organization
  before_action :organization
  include OrganizationsHelper

  def new
    @team = organization.teams.build
    authorize team
  end

  def edit
    authorize team
    @new_users = fetch_possible_new_users || []
    @new_projects = organization.projects.where.not(id: team.projects)
  end

  def create
    @team = Team.new(team_params.merge(organization_id: organization.id))
    authorize team
    team.save ? redirect_to_edit_team(:success, t('teams.create.success')) : (render 'new')
  end

  def update
    authorize team
    if team.update(team_params)
      redirect_to_edit_team(:success, t('teams.update.success'))
    else
      render 'new'
    end
  end

  def destroy
    authorize team
    if organization.admin_team?(team)
      return redirect_to_edit_organization(:error, t('teams.destroy.admin'))
    end
    if team.destroy
      redirect_to_edit_organization(:success, t('teams.destroy.success'))
    else
      render 'edit'
    end
  end

  private

  def fetch_possible_new_users
    users = OrganizationUsersQuery.new(team.organization).fetch
    users.where('users.id not in (?)', team.users.ids) if team.users.present?
    users
  end

  def team
    @team ||= Team.find(params[:id])
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end

  def team_params
    params.require(:team).permit(:name, :project_id, :user_id, :invite, :email)
  end
end
