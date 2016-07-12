class AddSlugToProject < ActiveRecord::Migration
  def change
    add_column :projects, :slug, :string, unique: true
    add_index :projects, [:organization_id, :slug], unique: true
  end
end
