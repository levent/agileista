namespace :task_developers do
  desc "migrate from developer to developers"
  task(:migrate => :environment) do
    Task.all.each do |task|
      if task.developer_id
        TaskDeveloper.create!(:task_id => task.id, :developer_id => task.developer_id)
        p "#{task.developers.first.name} for #{task.definition}"
      end
    end ; nil
  end
end