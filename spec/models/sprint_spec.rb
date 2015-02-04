require 'rails_helper'

RSpec.describe Sprint, type: :model do

  before do
    @it = Sprint.new
  end

  it { should have_many(:sprint_elements).dependent(:delete_all) }
  it { should have_many(:user_stories) }
  it { should have_many(:burndowns) }

  it { should belong_to :project }
  it { should validate_presence_of :project_id }
  it { should validate_presence_of :start_at }
  it { should validate_presence_of :end_at }
  it { should validate_presence_of :name }

  context "auto setting end time" do
    before do
      @project = create_project
    end

    it "should set it on save based on project's iteration length" do
      start = 1.day.from_now
      sprint = @project.sprints.create!(:name => "Disco dance prep", :start_at => start)
      expect(@project.iteration_length.weeks.from_now(1.day.ago(start)).end_of_day).to eq sprint.end_at
    end

    it "should set it to end of day on subsequent saves" do
      start = 19.days.from_now
      sprint = @project.sprints.create!(:name => "Disco dance prep", :start_at => start)
      finish = @project.iteration_length.weeks.from_now(1.day.ago(start))
      initial_finish = sprint.end_at
      sprint.end_at = finish
      sprint.save!
      sprint.reload
      expect(sprint.end_at.to_s).to eq initial_finish.to_s
    end
  end

  describe "#velocity" do
    before do
      us1 = UserStory.new(:story_points => 3)
      us2 = UserStory.new(:story_points => 12)
      us3 = UserStory.new(:story_points => 5)
      us4 = UserStory.new(:story_points => 8)
      us5 = UserStory.new(:story_points => 13)
      us6 = UserStory.new(:story_points => nil)
      us7 = UserStory.new(:story_points => 20)
      us8 = UserStory.new(:story_points => 40)

      allow(us1).to receive(:complete?) { true }
      allow(us2).to receive(:complete?) { true }
      allow(us3).to receive(:complete?) { false }
      allow(us4).to receive(:complete?) { true }
      allow(us5).to receive(:complete?) { true }
      allow(us6).to receive(:complete?) { false }
      allow(us7).to receive(:complete?) { true }
      allow(us8).to receive(:complete?) { false }

      @sprint = create_sprint
      allow(@sprint).to receive(:user_stories) { [us1, us2, us3, us4, us5, us6, us7, us8] }
      @sprint.start_at = 3.months.ago
      @sprint.end_at = 2.months.ago
    end

    it "should return the total story points for all the complete user stories" do
      expect(@sprint.calculated_velocity).to eq 56
      expect(@sprint.velocity).to eq 56
    end
  end

  describe "#validate" do
    it "should require start and end to be in right order" do
      @it.start_at = 1.day.from_now
      @it.end_at = 1.day.ago
      @it.validate
      expect(@it.errors[:start_at]).to include("and end at must be different")
    end
  end

  describe "#current?" do
    it "should return true if active sprint" do
      @it.start_at = 1.weeks.ago
      @it.end_at = 2.weeks.from_now
      expect(@it.current?).to be_truthy
    end

    it "should return false if complete" do
      @it.start_at = 2.weeks.ago
      @it.end_at = 1.weeks.ago
      expect(@it.current?).to be_falsey
    end

    it "should return false if upcoming" do
      @it.start_at = 1.weeks.from_now
      @it.end_at = 2.weeks.from_now
      expect(@it.current?).to be_falsey
    end
  end

  describe "#destroy" do
    describe "with user stories" do
      before(:each) do
        @sprint = create_sprint
        @user_story = create_user_story
        @user_story.sprint = @sprint
        @user_story.save!
        @user_story.reload
        @sprint_element = SprintElement.find_or_create_by(sprint_id: @sprint.id, user_story_id: @user_story.id)
      end

      it "should remove sprint_id reference" do
        expect(UserStory.where(sprint_id: @user_story.sprint.id)).not_to be_blank
        @sprint.destroy
        expect(UserStory.where(sprint_id: @sprint.id)).to be_blank
      end

      it "should remove sprint_elements" do
        @sprint_element.sprint.destroy
        expect(SprintElement.count).to eq 0
      end
    end
  end

  describe "#calculate_day_zero" do
    before do
      @sprint = create_sprint
    end

    it "should do nothing if sprint start elapsed" do
      expect(@sprint.calculate_day_zero).to be_falsey
    end

    it "should create first burndown entry if upcoming sprint" do
      @sprint.start_at = 1.week.from_now
      @sprint.end_at = 3.weeks.from_now
      @sprint.save!
      allow(@sprint).to receive(:hours_left) { 123 }

      @sprint.calculate_day_zero
      burndown = @sprint.burndowns.first
      expect(burndown.hours_left).to eq 123
    end
  end
end
