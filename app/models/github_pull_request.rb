class GithubPullRequest
  attr_reader :full_name, :sha, :branch

  def initialize(pull_request_data)
    @full_name = pull_request_data[:full_name]
    @sha = pull_request_data[:sha]
    @branch = pull_request_data[:branch]
  end
end
