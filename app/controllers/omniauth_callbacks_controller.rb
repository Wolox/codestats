class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_and_redirect(fetch_omniauth_user)
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
end
