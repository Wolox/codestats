class AddGithubShaToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :github_sha, :string
  end
end
