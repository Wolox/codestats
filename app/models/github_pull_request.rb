class GithubPullRequest
  attr_reader :pull_request

  def initialize(pull_request)
    @pull_request = pull_request
  end

  def full_name
    pull_request['base']['repo']['full_name']
  end

  def sha
    pull_request['head']['sha']
  end

  def branch
    pull_request['head']['ref']
  end
end
