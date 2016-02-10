class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :project, index: true, foreign_key: true
      t.string :name
      t.boolean :default

      t.timestamps null: false
    end
  end
end
