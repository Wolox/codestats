class AddBotAccessTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :bot_access_token, :string, default: nil
  end
end
