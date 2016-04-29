class GithubBranch
  attr_reader :name, :sha

  def initialize(github_branch_data)
    @name = github_branch_data[:name]
    @sha = github_branch_data[:commit][:sha]
  end
end
