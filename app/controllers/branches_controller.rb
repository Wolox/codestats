class BranchesController < ApplicationController
  before_action :authenticate_user!
  # Always preload organization and project
  before_action :organization, :project

  def index
    @branches = policy_scope(branches)
  end

  def show
    authorize branch
    @metrics = BranchLatestMetrics.new(branch).find
  end

  private

  def project
    @project ||= Project.friendly.find(params[:project_id])
  end

  def branch
    @branch ||= project.branches.friendly.find(params[:id]).decorate
  end

  def branches
    @branches ||= project.branches.order('branches.default DESC')
  end

  def organization
    @organization ||= Organization.friendly.find(params[:organization_id])
  end
end
