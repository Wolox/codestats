class TeamsController < ApplicationController
  # Preload organization
  before_action :organization

  def new
    @team = organization.teams.build
    authorize team
  end

  def edit
    authorize team
    fetch_possible_new_users
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
    if organization_admin_team?
      return redirect_to_edit_organization(:error, t('teams.destroy.admin'))
    end
    if team.destroy
      redirect_to_edit_organization(:success, t('teams.destroy.success'))
    else
      render 'edit'
    end
  end

  def add_user
    authorize team, :update?
    user = User.find_by_id(team_params[:user_id]) || User.find_by_email(team_params[:email])
    return add_existent_user(user) if user.present?
    add_new_invitable_user
  end

  def add_project
    authorize team, :update?
    if includes_project?
      return redirect_to_edit_team(:error, t('teams.projects.add.exists'))
    end
    team.projects << Project.find(team_params[:project_id])
    redirect_to_edit_team(:success, t('teams.projects.add.success'))
  end

  def delete_user
    authorize team, :update?
    unless includes_user?(team_params[:user_id])
      return redirect_to_edit_team(:error, t('teams.users.delete.not_exists'))
    end
    team.users.delete(User.find(team_params[:user_id].to_i))
    redirect_to_edit_team(:success, t('teams.users.delete.success'))
  end

  def delete_project
    authorize team, :update?
    unless includes_project?
      return redirect_to_edit_team(:error, t('teams.projects.delete.not_exists'))
    end
    team.projects.delete(Project.find(team_params[:project_id].to_i))
    redirect_to_edit_team(:success, t('teams.projects.delete.success'))
  end

  private

  def add_new_invitable_user
    if team_params[:invite].present? && team_params[:email].present?
      user = User.invite!(email: team_params[:email])
      team.users << user
      redirect_to_edit_team(:success, t('teams.users.invited.success'))
    end
  end

  def add_existent_user(user)
    if includes_user?(user.id)
      return redirect_to_edit_team(:error, t('teams.users.add.exists'))
    end
    team.users << user
    redirect_to_edit_team(:success, t('teams.users.add.success'))
  end

  def organization_admin_team?
    team == organization.admin_team
  end

  # TODO: Make a query object
  def fetch_possible_new_users
    @new_users = User.joins(:teams).where('teams.organization_id = ?', team.organization.id)
    @new_users = @new_users.where('users.id not in(?)', team.users.ids) if team.users.present?
  end

  def redirect_to_edit_organization(type_message, message)
    redirect_to edit_organization_path(organization),
                flash: { type_message => message }
  end

  def redirect_to_edit_team(type_message, message)
    redirect_to edit_organization_team_path(organization, team),
                flash: { type_message => message }
  end

  def includes_user?(user_id)
    return false unless user_id.present?
    team.user_ids.include?(user_id.to_i)
  end

  def includes_project?
    team.project_ids.include?(team_params[:project_id].to_i)
  end

  def team
    @team ||= Team.find(params[:id])
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end

  def team_params
    params.require(:team).permit(:name, :project_id, :user_id, :invite, :email)
  end
end
