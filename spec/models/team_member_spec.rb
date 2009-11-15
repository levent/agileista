require File.dirname(__FILE__) + '/../spec_helper'

describe TeamMember do

  context "developers" do
    before(:each) do
      @team_member = TeamMember.make
    end
    
    it "should return an array of developers assigned to this task" do
      @team_member.tasks.should be_blank
      @task1 = Task.make
      @task2 = Task.make
      @team_member.tasks << @task1
      @team_member.tasks << @task2
      @team_member.tasks.should == [@task1, @task2]
    end
  end
end