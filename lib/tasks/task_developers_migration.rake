namespace :task_developers do
  desc "migrate from developer to developers"
  task(:migrate => :environment) do
    Task.all.each do |task|
      if task.developer
        task.developers = [task.developer]
        task.save!
        p "#{task.developer.name} to [#{task.developers.first.name}] for #{task.definition}"
      end
    end ; nil
  end
end