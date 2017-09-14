class GithubService < SimpleDelegator
  class MissingAccessTokenException < StandardError; end
  attr_reader :client
  Octokit.auto_paginate = true

  def initialize(access_token)
    raise MissingAccessTokenException unless access_token.present?
    @client = Octokit::Client.new(
      access_token: access_token,
      client_id: Rails.application.secrets.github_client_id,
      client_secret: Rails.application.secrets.github_client_secret)
    super @client
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

  def get_pull_request_branch(repo_name, pull_request_number, options = {})
    client.pull_request(repo_name, pull_request_number, options)[:head][:ref]
  end

  # TODO: Improve this. It will fail if there are two pull requests for the same branch.
  # Saving the pull request data after the creation webhook can solve it
  def get_pull_request_by_sha(repo_name, sha)
    client.pull_requests(repo_name).select { |data| data['head']['sha'] == sha }[0]
  end

  def create_status(pull_request, status, options = {})
    client.create_status(pull_request.full_name, pull_request.sha, status, options)
  end

  def create_webhook(repo_full_name, url, events, content_type = 'form')
    client.create_hook(
      repo_full_name,
      'web',
      { url: url, content_type: content_type },
      events: events, active: true
    )
  end
end
