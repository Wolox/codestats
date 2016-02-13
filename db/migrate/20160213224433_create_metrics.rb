class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.references :branch, index: true, foreign_key: true
      t.string :name
      t.string :value
      t.string :url

      t.timestamps null: false
    end
  end
end
