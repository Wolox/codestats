class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  include Pundit

  # All action should be authorized
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index
end
