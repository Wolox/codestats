class BranchesController < ApplicationController
  # Always preload organization and project
  before_action :organization, :project

  def index
    branches
  end

  def show
    branch
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
