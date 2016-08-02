class GithubIssueCommenter
  class PullRequestNumberNotFoundException < StandardError; end
  include Sidekiq::Worker
  attr_reader :project, :branch, :pull_request, :github_service

  def perform(project_id, branch_id, pull_request_data)
    @pull_request = GithubPullRequest.new(pull_request_data)
    @project = Project.find(project_id)
    fetch_pull_request_number
    raise PullRequestNumberNotFoundException unless pull_request.number.present?
    @branch = Branch.find(branch_id)
    send_comment(generate_comments)
  end

  private

  def fetch_pull_request_number
    pr_resource = github_service.get_pull_request_by_sha(project.github_repo, pull_request.sha)
    return if pr_resource.nil?
    pull_request.number = pr_resource[:number]
  end

  def generate_comments
    comments = ["**CodeStats metrics details:**\n\n"]
    BranchLatestMetrics.new(branch).find.each do |metric|
      comments << generate_comment_for(metric)
    end
    comments << ["\n\nClick [here](#{BranchManager.new(branch).target_url}) for more details."]
    comments.join
  end

  def generate_comment_for(metric)
    status = MetricManager.new(metric).status_success?
    status ? success_comment(metric) : failure_comment(metric)
  end

  def success_comment(metric)
    ":white_check_mark: #{metric.name}: #{metric.value.to_f.round(2)}\n"
  end

  def failure_comment(metric)
    ":x: #{metric.name}: #{metric.value.to_f.round(2)} - Minimum: #{metric.minimum}\n"
  end

  def send_comment(comment)
    github_service.add_comment(project.github_repo, pull_request.number, comment)
  end

  def github_service
    @github_service ||= GithubService.new(project.admin_user)
  end
end
