class ProjectGithubWebhookCreation
  include Sidekiq::Worker
  sidekiq_options retry: false
  attr_reader :project

  def perform(project_id)
    @project = Project.find(project_id)
    GithubService.new(project.organization.admin_user).create_webhook(
      project.github_repo, Rails.application.secrets.github_webhook_url, ['status']
    )
  rescue Octokit::UnprocessableEntity
    Rails.logger.error('Webhook already exists')
  end
end
