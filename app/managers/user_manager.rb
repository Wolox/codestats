class UserManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # Merge an existent user with a new one
  # This method is usefull when you invite a user that was already created
  # Keeps the first user and destroys the other_user
  def merge!(other_user)
    user.teams << other_user.teams.where.not(id: user.teams.pluck(:id))
    other_user.destroy!
    user
  end
end
