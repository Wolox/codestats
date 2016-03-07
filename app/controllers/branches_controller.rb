class BranchesController < ApplicationController
  # Always preload organization and project
  before_action :authenticate_user!
  before_action :organization, :project

  def index
    @branches = policy_scope(branches)
  end

  def show
    authorize branch
    @metrics = branch.metrics
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end

  def branch
    @branch ||= Branch.find(params[:id])
  end

  def branches
    @branches ||= project.branches.order('branches.default DESC')
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end
end
