class GithubPullRequestsController < ActionController::Base
  def create
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'status'
      handle_status
    end
    head :ok
  end

  private

  def handle_status
    payload = JSON.parse(params[:payload])
    if continuos_integration_success_status?(payload)
      AnalyzeGithubMetricsStatus.perform_async(
        sha: payload['sha'], full_name: payload['name'], branch: payload['branches'].last['name']
      )
    end
  end

  def continuos_integration_success_status?(payload)
    payload['context'].downcase.include?('ci') && payload['state'] == 'success'
  end
end
