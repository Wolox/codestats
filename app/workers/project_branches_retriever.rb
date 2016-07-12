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
    delete_branches(branches.map { |b| b['name'] })
  end

  private

  # Delete branches that were deleted in Github
  def delete_branches(github_branches)
    logger.info "Current Github Branches: #{github_branches}"
    project.branches.find_each do |branch|
      next if github_branches.include?(branch.name)
      logger.info "Deleting #{branch.name}"
      branch.destroy
    end
  end

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
