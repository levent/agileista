require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Theme do
  it {should belong_to(:account)}
  it {should validate_presence_of(:name)}
  
  describe "acts as list" do
    before(:each) do
      Theme.destroy_all
    end
    
    it "should increment on create" do
      Theme.create!(:name => "T1").position.should == 1
      Theme.create!(:name => "T2").position.should == 2
    end
  end
  
  context "story points left" do
    before(:each) do
      @theme = Theme.make
      @us1 = UserStory.make(:story_points => 13, :themes => [@theme])
      @us2 = UserStory.make(:story_points => nil, :themes => [@theme], :tasks => [Task.make])
      @us3 = UserStory.make(:story_points => 8, :themes => [@theme], :tasks => [Task.make])
    end
    
    it "should tell you how many story points are left to complete" do
      complete_task = @us3.tasks.first
      complete_task.hours = 0
      complete_task.save!
      @us3.complete?.should be_true
      @theme.story_points_left.should == 13
    end
    
    it "should treat null story points as 0" do
      complete_task = @us2.tasks.first
      complete_task.hours = 0
      complete_task.save!
      @us2.complete?.should be_true
      @theme.story_points_left.should == 13 + 8
    end
  end
end