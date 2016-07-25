class GithubReposRetriever
  attr_reader :organization, :user, :service
  def execute(user_id, organization_id)
    fetch_entities(user_id, organization_id)
    repos = service.org_admin_repos(organization.github_name, per_page: 400)
    selected = repos.select! { |r| !projects&.pluck(:github_repo).include?(r.full_name) }
    [200, selected.map(&:to_hash)]
  end

  def projects
    @projects ||= organization.projects
  end

  def fetch_entities(user_id, organization_id)
    @user = User.find(user_id)
    @organization = Organization.find(organization_id)
    @service = GithubService.new(user)
  end
end
