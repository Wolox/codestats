class AddSlugToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :slug, :string, unique: true
    add_index :organizations, :slug, unique: true
  end
end
