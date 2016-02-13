class BranchesController < ApplicationController
  def index
    organization
    branches
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end

  def branches
    @branches ||= project.branches.order('branches.default DESC')
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end
end
