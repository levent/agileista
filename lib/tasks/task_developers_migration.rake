namespace :task_developers do
  desc "migrate from developer to developers"
  task(:migrate => :environment) do
    Task.all.each do |task|
      if task.developer_id
        team_member = TeamMember.find(task.developer_id)
        task.developers = [team_member]
        task.save!
        p "#{team_member.name} to [#{task.developers.first.name}] for #{task.definition}"
      end
    end ; nil
  end
end