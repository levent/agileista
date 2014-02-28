require 'unit_helper'
require 'velocity'

describe Velocity do

  describe ".confidence_interval" do
    it "should require at least five values" do
      Velocity.confidence_interval([1,2,3,4]).should be_nil
    end

    it "should return the correct interval" do
      REDIS.should_receive(:get).with('17-18-20-20-21-23-23-27')
      REDIS.should_receive(:get).with('17+18+20+20+21+23+23+27')
      REDIS.should_receive(:set).with('17-18-20-20-21-23-23-27', 18)
      REDIS.should_receive(:set).with('17+18+20+20+21+23+23+27', 23)
      ci = Velocity.confidence_interval([17, 18, 20, 20, 21, 23, 23, 27])
      ci.first.to_i.should == 18
      ci.last.to_i.should == 23
      ci.size.should == 2
    end
  end

  describe ".stats_significant_since" do
    before do
      Timecop.freeze
      @project = instance_double("Project")
      @project.stub(:id).and_return(13)
      sprint = instance_double("Sprint")
      sprint.stub(:try).with(:start_at).and_return(Time.now)
      @sprints = [sprint]
    end

    after do
      Timecop.return
    end

    it "should get date from Redis" do
      REDIS.should_receive(:get).with("project:13:stats_since").and_return('date')
      Velocity.stats_significant_since(@project).should == 'date'
    end

    it "should get date from first sprint if not in Redis" do
      @project.should_receive(:sprints).and_return(@sprints)
      @sprints.should_receive(:finished).and_return(@sprints)
      REDIS.should_receive(:get).with("project:13:stats_since")
      Velocity.stats_significant_since(@project).should == Time.now
    end
  end

  describe ".stats_significant_since_sprint_id" do
    it "should check Redis for first significant sprint" do
      REDIS.should_receive(:get).with("project:19:stats_since:sprint_id").and_return(12)
      Velocity.stats_significant_since_sprint_id(19).should == 12
    end
  end

end
