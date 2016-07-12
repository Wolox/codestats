class TeamsProjectsController < ApplicationController
  before_action :authenticate_user!
  # Preload organization
  before_action :organization
  include OrganizationsHelper

  def create
    authorize team, :update?
    if team.includes_project?(project)
      return redirect_to_edit_team(:error, t('teams.projects.add.exists'))
    end
    team.projects << project
    redirect_to_edit_team(:success, t('teams.projects.add.success'))
  end

  def destroy
    authorize team, :update?
    unless team.includes_project?(project)
      return redirect_to_edit_team(:error, t('teams.projects.delete.not_exists'))
    end
    team.projects.delete(project)
    redirect_to_edit_team(:success, t('teams.projects.delete.success'))
  end

  private

  def team
    @team ||= Team.find(params[:team_id])
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end

  def project
    @project ||= Project.friendly.find(params[:id])
  end
end
