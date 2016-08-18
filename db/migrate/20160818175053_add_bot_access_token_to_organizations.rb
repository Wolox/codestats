class AddBotAccessTokenToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :bot_access_token, :string, default: nil
  end
end
