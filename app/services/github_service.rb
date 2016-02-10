class GithubService
  attr_reader :user, :client
  def initialize(user)
    @user = user
    @client = Octokit::Client.new(access_token: user.auth_token)
  end

  def org_admin_repos(org, options = {})
    org_repos(org, options).select { |r| r.permissions[:admin] }
  end

  def org_repos(org, options = {})
    client.organization_repositories(org, options)
  end

  def get_organizations(options = {})
    client.organizations(options)
  end

  def get_repo(name)
    client.repo(name)
  end

  def branches(repo)
    client.branches(repo)
  end
end
