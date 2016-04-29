class InvitationsController < Devise::InvitationsController
  def edit
    redirect_to root_path(invitation_token: params[:invitation_token])
  end
end
