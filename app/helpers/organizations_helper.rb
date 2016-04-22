module OrganizationsHelper
  def redirect_to_edit_organization(type_message, message)
    redirect_to edit_organization_path(organization), flash: { type_message => message }
  end

  def redirect_to_edit_team(type_message, message)
    redirect_to edit_organization_team_path(organization, team), flash: { type_message => message }
  end
end
