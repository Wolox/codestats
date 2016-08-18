class GithubOrganizationsRetriever
  def execute(user_id)
    user = User.find(user_id)
    service = GithubService.new(user.auth_token)
    github_orgs = service.get_organizations(per_page: 400)
    orgs = github_orgs.select! { |o| !existing_organizations(user).include?(o.login) }
    [200, orgs.map(&:to_hash)]
  end

  def existing_organizations(user)
    @existing ||= user.organizations.pluck(:github_name)
  end
end
