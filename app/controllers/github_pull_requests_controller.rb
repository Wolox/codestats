class GithubPullRequestsController < ActionController::Base
  def create
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'pull_request'
      if %w(create reopened opened).include?(params[:action])
        AnalyzeGithubMetricsStatus.perform_async(params[:pull_request])
      end
    end
    head :ok
  end
end
