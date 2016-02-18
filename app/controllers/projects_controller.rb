class ProjectsController < ApplicationController
  # Always preload organization
  before_action :organization

  def index
    redirect_to new_organization_project_path(organization) unless projects.present?
  end

  def new
    unless organization.github_name.present?
      return redirect_to edit_organization_path(organization),
                         flash: { error: t('organizations.missing_github_link') }
    end
    # TODO: this should be done over ajax so the user does not notice the delay
    github_non_linked_repos
  end

  def create
    repo = github_service.get_repo(params[:name])
    project = projects.create(name: repo.name, github_repo: repo.full_name)
    project.generate_metrics_token
    update_branches(project)
    redirect_to organization_project_path(organization, project),
                flash: { notice: t('projects.create.success') }
  end

  def show
    @project = Project.find(params[:id])
    @default_branch = @project.default_branch
    @metrics = @default_branch.metrics if @default_branch.present?
  end

  private

  def update_branches(project)
    return unless project.github_repo.present?
    ProjectBranchesRetriever.perform_async(current_user.id, project.id)
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

  def projects
    @projects ||= organization.projects
  end
end
