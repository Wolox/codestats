class AddGithubNickAndAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_nickname, :string
    add_column :users, :github_avatar_url, :string
  end
end
