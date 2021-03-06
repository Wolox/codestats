class ProjectsController < ApplicationController
  before_action :authenticate_user!
  # Always preload organization
  before_action :organization

  CHECKED = 1

  def index
    redirect_to new_organization_project_path(organization) unless projects.present?
    @projects = ProjectDecorator.decorate_collection(
      policy_scope(organization.projects.order(:name))
    )
  end

  def new
    authorize organization, :edit?
    unless organization.github_name.present?
      return redirect_to edit_organization_path(organization),
                         flash: { error: t('organizations.missing_github_link') }
    end
    async_fetch_projects
  end

  def create
    authorize organization, :edit?
    project = ProjectManager.new(organization.projects.build).create(github_repo)
    redirect_to edit_organization_project_path(organization, project),
                flash: { notice: t('projects.create.success') }
  end

  def show
    authorize project
    @metrics = MetricDecorator.decorate_collection(project.default_branch_metrics)
    @branch = project.default_branch&.decorate
  end

  def edit
    authorize project
    @teams = organization.teams
  end

  def update
    authorize project
    if project.update(project_params)
      reset_token
      redirect_to edit_path(success: t('projects.update.success'))
    else
      render 'edit'
    end
  end

  def destroy
    authorize project
    if project.destroy
      redirect_to organization_projects_path, flash: { success: t('projects.destroy.success') }
    else
      render 'edit'
    end
  end

  private

  def async_fetch_projects
    id = execute_async(GithubReposRetriever, current_user.id, organization.id)
    @projects_url = async_request.job_url(id)
  end

  def reset_token
    ProjectManager.new(project).generate_metrics_token if params[:reset_token].to_i == CHECKED
  end

  def edit_path(flash_messages)
    edit_organization_project_path(organization, project, flash: flash_messages)
  end

  def github_repo
    github_service.get_repo(params[:name])
  end

  def github_non_linked_repos
    @repos = github_service.org_admin_repos(organization.github_name, per_page: 400)
    @repos.select! { |r| !projects&.pluck(:github_repo).include?(r.full_name) }
  end

  def github_service
    GithubService.new(current_user.auth_token)
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end

  def project
    @project ||= organization.projects.friendly.find(params[:id])
  end

  def projects
    @projects ||= organization.projects
  end

  def project_params
    params.require(:project).permit(:bot_access_token, team_ids: [])
  end
end
