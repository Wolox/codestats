class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    if params[:invitation_token].present?
      user = resource_from_invitation_token
      return redirect_to new_user_session_path,
                         flash: {
                            error: 'devise.invitations.invitation_token_invalid'
                          } unless user.present?
      user = User.omniauth_invitable(request.env['omniauth.auth'], user)
    else
      user = User.from_omniauth(request.env['omniauth.auth'])
    end
    sign_in_and_redirect user
  end

  private

  def resource_from_invitation_token
    User.find_by_invitation_token(params[:invitation_token], true)
  end
end
