class OmniauthUser
  def self.from_omniauth(auth)
    github_info = GithubAuthInfo.new(auth)
    user = find_or_create_omniauth(github_info)
    user.update!(email: github_info.email, auth_token: github_info.auth_token)
    user
  end

  # If the user invited logs in with an existant Github account
  # then it returns the old account and destroys the new one
  def self.omniauth_invitable(auth, invited_user)
    github_info = GithubAuthInfo.new(auth)
    user = find_or_create_omniauth(github_info)
    invited_user.destroy! if user != invited_user
    user.update!(auth_token: github_info.auth_token)
    user.accept_invitation!
    user
  end

  def self.find_by_invitation_token(token)
    User.find_by_invitation_token(token, true)
  end

  def self.find_or_create_omniauth(github_info)
    User.where(provider: github_info.provider, uid: github_info.uid).first_or_create do |user|
      github_info.omniauth_info.each { |key, value| user.send("#{key}=", value) }
      user.password = default_password
    end
  end

  def self.default_password
    Devise.friendly_token[0, 20]
  end

  private_class_method :find_or_create_omniauth, :default_password
end
