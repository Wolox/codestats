class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :project, index: true, foreign_key: true
      t.string :name
      t.boolean :default, default: false

      t.timestamps null: false
    end
    add_index :branches, [:project_id, :name], unique: true
  end
end
