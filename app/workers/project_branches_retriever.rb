class ProjectBranchesRetriever
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, project_id)
    @user_id = user_id
    @project_id = project_id
    return unless project.present?
    update_branches
  end

  def update_branches
    branches.each { |branch| create_or_update(GithubBranch.new(branch)) }
  end

  private

  def create_or_update(github_branch)
    BranchManager.new(
      project.branches.find_or_initialize_by(name: github_branch.name)
    ).create_or_update(github_branch, repo_info[:default_branch])
  end

  def github_service
    @service ||= GithubService.new(user)
  end

  def user
    @user ||= User.find(@user_id)
  end

  def project
    @project ||= Project.find(@project_id)
  end

  def repo_info
    @repo_info ||= github_service.get_repo(project.github_repo)
  end

  def branches
    @branches ||= github_service.branches(project.github_repo)
  end
end
