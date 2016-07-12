class AddSlugToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :slug, :string, unique: true
    add_index :branches, [:project_id, :slug], unique: true
  end
end
