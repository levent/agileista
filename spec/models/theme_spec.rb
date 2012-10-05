require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Theme do
  it {should belong_to(:account)}
  it {should validate_presence_of(:name)}

  context "story points left" do
    before do
      @account = Account.make!
      @theme = Theme.make!
      @us1 = UserStory.make!(:story_points => 13, :themes => [@theme], :account => @account)
      @us2 = UserStory.make!(:story_points => nil, :themes => [@theme], :tasks => [Task.make], :account => @account)
      @us3 = UserStory.make!(:story_points => 8, :themes => [@theme], :tasks => [Task.make], :account => @account)
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
