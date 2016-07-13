# frozen_string_literal: true
class BadgesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :error_badge

  ERROR_BADGE = 'badge-error-lightgrey.svg'
  SUCCESS_BADGE = 'checks-passed-green.svg'
  FAIL_BADGE = 'checks-failed-red.svg'

  def index
    branch = organization.projects.friendly.find(params[:id]).default_branch
    file = get_badge_for_branch(branch)
    send_data open(file).read, type: 'image/svg+xml;charset=utf-8', disposition: :inline
  end

  private

  def error_badge
    file = asset_path(ERROR_BADGE)
    send_data open(file).read, type: 'image/svg+xml;charset=utf-8', disposition: :inline
  end

  def get_badge_for_branch(branch)
    return asset_path(ERROR_BADGE) if branch.nil?
    if BranchManager.new(branch).metrics_status_success?
      asset_path(SUCCESS_BADGE)
    else
      asset_path(FAIL_BADGE)
    end
  end

  def asset_path(name)
    Rails.root.join('public', name)
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end
end
