class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :github_repo
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
