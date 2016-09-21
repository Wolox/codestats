class TeamsUsersController < ApplicationController
  before_action :authenticate_user!
  # Preload organization
  before_action :organization
  include OrganizationsHelper

  def create
    authorize team, :update?
    user = User.find_by_id(params[:id]) || User.find_by_email(params[:email])
    user.present? ? add_existent_user(user) : add_new_invitable_user
  end

  def destroy
    authorize team, :update?
    return redirect_to_edit_team(:error, t('teams.users.delete.not_exists')) unless includes_user?
    team.users.delete(User.find(params[:id]))
    redirect_to_edit_team(:success, t('teams.users.delete.success'))
  end

  private

  def includes_user?(user_id = params[:id])
    user_id.present? ? team.user_ids.include?(user_id.to_i) : false
  end

  def add_existent_user(user)
    return redirect_to_edit_team(:error, t('teams.users.add.exists')) if includes_user?(user.id)
    team.users << user
    redirect_to_edit_team(:success, t('teams.users.add.success'))
  end

  def add_new_invitable_user
    return unless valid_invitable_params?
    user = User.find_by_email(team_users_params[:email])
    team.users << (user || User.invite!(email: team_users_params[:email]))
    redirect_to_edit_team(:success, t('teams.users.invited.success'))
  end

  def valid_invitable_params?
    team_users_params[:invite].present? && team_users_params[:email].present?
  end

  def team
    @team ||= Team.find(params[:team_id])
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end

  def team_users_params
    params.require(:team_users).permit(:invite, :email)
  end
end
