class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize user
  end

  def edit
    authorize user
  end

  def update
    authorize user
    if user.update(user_params)
      redirect_to user
    else
      render 'edit'
    end
  end

  private

  def user
    @user ||= User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
