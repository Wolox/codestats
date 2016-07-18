class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, unique: true
    add_index :users, :slug, unique: true
  end
end
