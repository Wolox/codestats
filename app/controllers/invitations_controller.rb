class InvitationsController < Devise::InvitationsController
  def edit
    redirect_to new_user_session_path(invitation_token: params[:invitation_token])
  end
end
