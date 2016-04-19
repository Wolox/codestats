class LandingController < ActionController::Base
  layout 'application'

  def index
    return redirect_to organizations_path if user_signed_in?
  end
end
