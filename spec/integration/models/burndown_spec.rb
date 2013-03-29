require 'spec_helper'

describe Burndown do
  it {should belong_to(:sprint)}
  it {should validate_presence_of(:sprint_id)}

  context "sort order" do
    it "should be ordered by date by default" do
      project = Project.make!
      sprint = Sprint.make!(:project => project)
      b1 = Burndown.make!(:created_on => 3.days.ago, :sprint => sprint)
      b4 = Burndown.make!(:created_on => 6.days.ago, :sprint => sprint)
      b2 = Burndown.make!(:created_on => 4.days.ago, :sprint => sprint)
      b3 = Burndown.make!(:created_on => 5.days.ago, :sprint => sprint)
      b5 = Burndown.make!(:created_on => 7.days.ago, :sprint => sprint)
      Burndown.all.should == [b5, b4, b3, b2, b1]
    end
  end
end

