class BadgesController < ApplicationController
  def index
    branch = organization.projects.friendly.find(params[:id]).default_branch
    file = get_badge_for_branch(branch)
    send_data open(file).read, type: 'image/svg+xml;charset=utf-8', disposition: :inline
  end

  private

  def get_badge_for_branch(branch)
    if BranchManager.new(branch).metrics_status_success?
      Rails.root.join('public', 'checks-passed-green.svg')
    else
      Rails.root.join('public', 'checks-failed-red.svg')
    end
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end
end
