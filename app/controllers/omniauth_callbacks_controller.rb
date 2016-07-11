class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = fetch_omniauth_user
    return redirect_to :root unless allowed_organization?(github_service(user))
    sign_in_and_redirect(user)
  end

  private

  def fetch_omniauth_user
    if params[:invitation_token].present?
      user = resource_from_invitation_token
      return redirect_invalid_user unless user.present?
      OmniauthUser.omniauth_invitable(request.env['omniauth.auth'], user)
    else
      OmniauthUser.from_omniauth(request.env['omniauth.auth'])
    end
  end

  def redirect_invalid_user
    redirect_to new_user_session_path, flash: {
      error: t('devise.invitations.invitation_token_invalid')
    }
  end

  def resource_from_invitation_token
    OmniauthUser.find_by_invitation_token(params[:invitation_token])
  end

  def github_service(user)
    @service ||= GithubService.new(user)
  end

  def allowed_organization?(service)
    user_orgs = service.organizations.map { |a| a['login'].downcase }
    allowed = Rails.application.secrets.allowed_organizations.map(&:downcase)
    allowed.any? { |e| user_orgs.include? e }
  end
end
