namespace :sprint_changes do
  namespace :mung do
    desc "Associate sprint changes to user stories not sprint elements"
    task(:element_to_user_story => :environment) do
      SprintChange.all(:conditions => ["auditable_type = 'SprintElement'"]).each do |sc|
        sc.auditable = sc.auditable.user_story if sc.auditable
        sc.save!
      end
      
      SprintChange.all(:conditions => ["auditable_type = 'UserStory'"]).each do |sc|
        sc.details = sc.details.gsub(/#[0-9][0-9][0-9][0-9][ ]/, '')
        sc.save!
      end
    end
  end
end
