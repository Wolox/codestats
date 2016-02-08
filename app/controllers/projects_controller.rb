class ProjectsController < ApplicationController
  def index
    @projects = current_user.organization&.projects
    redirect_to new_project_path unless @projects.present?
  end

  def new
    # TODO: this should be done over ajax so the user does not notice the delay
    @repos = github_service.org_admin_repos(current_user.organization&.name, per_page: 400)
    @repos.select! { |r| !existing_projects.include?(r.full_name) }
  end

  def create
    repo = github_service.get_repo(params[:name])
    project = current_user.organization.projects.create(
      name: repo.name, github_repo: repo.full_name
    )
    redirect_to project_path(project)
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def github_service
    GithubService.new(current_user)
  end

  def existing_projects
    # TODO: Add teams here
    @existing ||= current_user.organization&.projects&.pluck(:github_repo)
  end
end
