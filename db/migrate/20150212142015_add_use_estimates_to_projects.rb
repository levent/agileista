class AddUseEstimatesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :use_estimates, :boolean, default: true
  end
end
