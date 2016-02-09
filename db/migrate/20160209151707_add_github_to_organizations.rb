class AddGithubToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :github_name, :string
    add_column :organizations, :github_url, :string
    add_column :organizations, :github_avatar_url, :string
  end
end
