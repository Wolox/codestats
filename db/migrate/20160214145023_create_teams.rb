class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :organization, index: true, foreign_key: true
      t.string :name
      t.boolean :admin, default: false

      t.timestamps null: false
    end

    create_table :projects_teams, id: false do |t|
      t.belongs_to :team, index: true
      t.belongs_to :project, index: true
    end

    create_table :teams_users, id: false do |t|
      t.belongs_to :team, index: true
      t.belongs_to :user, index: true
    end
  end
end
