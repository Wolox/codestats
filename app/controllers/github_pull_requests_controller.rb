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
    if continuos_integration_success_status?
      AnalyzeGithubMetricsStatus.perform_async(
        sha: params[:sha], full_name: params[:name], branch: params[:branches].last[:name]
      )
    end
  end

  def continuos_integration_success_status?
    params[:context].downcase.include?('ci') && params[:state] == 'success'
  end
end
