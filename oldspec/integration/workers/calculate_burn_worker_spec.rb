require 'spec_helper'

describe CalculateBurnWorker do
  before do
    @project = Project.make!
    @sprint = Sprint.make!(project: @project)
  end

  it "should create a burndown entry for the date and sprint" do
    CalculateBurnWorker.new.perform(Date.today, @sprint.id)
    burndown = @sprint.burndowns.last
    burndown.created_on.should == Date.today
    burndown.hours_left.should == 0
  end
end
