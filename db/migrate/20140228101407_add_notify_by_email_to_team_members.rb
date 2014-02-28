class AddNotifyByEmailToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :notify_by_email, :boolean, default: false
  end
end
