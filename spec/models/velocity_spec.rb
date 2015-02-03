require 'rails_helper'

RSpec.describe Velocity, type: :model do

  describe ".confidence_interval" do
    it "should require at least five values" do
      expect(Velocity.confidence_interval([1,2,3,4])).to be_nil
    end

    it "should return the correct interval" do
      ci = Velocity.confidence_interval([17, 18, 20, 20, 21, 23, 23, 27])
      expect(ci.first.to_i).to eq 18
      expect(ci.last.to_i).to eq 23
      expect(ci.size).to eq 2
    end
  end

  describe ".stats_significant_since" do
    before do
      Timecop.freeze
      @project = create_project
      @project.sprints = [create_sprint]
    end

    after do
      Timecop.return
    end

    it "should get date from Redis" do
      REDIS.set("project:#{@project.id}:stats_since", 'date')
      expect(Velocity.stats_significant_since(@project)).to eq 'date'
    end

    it "should get date from first sprint if not in Redis" do
      REDIS.del("project:#{@project.id}:stats_since")
      expect(Velocity.stats_significant_since(@project)).to eq Time.now
    end
  end

  describe ".stats_significant_since_sprint_id" do
    it "should check Redis for first significant sprint" do
      @project = create_project
      REDIS.set("project:#{@project.id}:stats_since:sprint_id", 12)
      expect(Velocity.stats_significant_since_sprint_id(@project.id).to_i).to eq 12
    end
  end

end
