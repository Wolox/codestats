class OrganizationsController < ApplicationController
  def edit
    organization
  end

  def update
    if organization.update(organization_params)
      redirect_to root_path, flash: { success: t('organizations.update.success') }
    else
      render 'edit'
    end
  end

  private

  def organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
