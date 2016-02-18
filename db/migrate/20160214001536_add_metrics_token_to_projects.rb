class AddMetricsTokenToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :metrics_token, :string

    Project.find_each do |project|
      project.generate_metrics_token
    end
  end

  def down
    remove_column :projects, :metrics_token
  end
end
