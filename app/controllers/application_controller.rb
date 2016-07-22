class ApplicationController < ActionController::Base
  protect_from_forgery
  include Pundit

  protected

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include AsyncRequest::ApplicationHelper

  def user_not_authorized
    flash[:alert] = t('policies.not_authorized')
    redirect_to(request.referrer || root_path)
  end

  # Redirect to '/' instead of /users/sign_in
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path
    end
  end

  # After sign in url for devise
  def after_sign_in_path_for(_resource)
    organizations_path
  end
end
