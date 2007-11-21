class SprintElementsInUseAgain < ActiveRecord::Migration
  def self.up
    for us in UserStory.find(:all)
      begin
        SprintElement.create(:user_story => us, :sprint => Sprint.find(us.sprint_id))
      rescue
        puts "Sprint with id #{us.sprint_id} does not exist"
      end
    end
  end

  def self.down
  end
end
