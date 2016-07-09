class ProjectsController < ApplicationController
  before_action :authenticate_user!
  # Always preload organization
  before_action :organization

  def index
    redirect_to new_organization_project_path(organization) unless projects.present?
    @projects = policy_scope(organization.projects)
  end

  def new
    authorize organization, :edit?
    unless organization.github_name.present?
      return redirect_to edit_organization_path(organization),
                         flash: { error: t('organizations.missing_github_link') }
    end
    # TODO: this should be done over ajax so the user does not notice the delay
    github_non_linked_repos
  end

  def create
    authorize organization, :edit?
    project = ProjectManager.new(organization.projects.build).create(github_repo)
    redirect_to organization_project_path(organization, project),
                flash: { notice: t('projects.create.success') }
  end

  def show
    authorize project
    @default_branch = project.default_branch
    @metrics = LatestMetrics.new(@default_branch).find if @default_branch.present?
  end

  private

  def github_repo
    github_service.get_repo(params[:name])
  end

  def github_non_linked_repos
    @repos = github_service.org_admin_repos(organization.github_name, per_page: 400)
    @repos.select! { |r| !projects&.pluck(:github_repo).include?(r.full_name) }
  end

  def github_service
    GithubService.new(current_user)
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end

  def project
    @project ||= Project.find(params[:id])
  end

  def projects
    @projects ||= organization.projects
  end
end
