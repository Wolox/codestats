class ApplicationController < ActionController::Base
  protect_from_forgery
  include Pundit

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path
    end
  end
end
