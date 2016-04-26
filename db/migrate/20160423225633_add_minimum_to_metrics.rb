class AddMinimumToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :minimum, :decimal
  end
end
