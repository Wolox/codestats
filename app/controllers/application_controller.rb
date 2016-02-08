class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    @repos = GithubService.new(current_user).org_admin_repos(
      current_user.organization.try(:name),
      per_page: 400
    )
  end
end
