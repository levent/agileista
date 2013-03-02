require 'spec_helper'

describe SprintsHelper, :type => :helper do
  before do
    @it = helper
    @project = Project.make!
    @sprint = Sprint.make!(:project => @project)
  end

  describe "#sprint_header" do
    before do
      @it.stub(:current_user).and_return(false)

      @it.stub(:show_date).with(@sprint.start_at).and_return('START')
      @it.stub(:show_date).with(@sprint.end_at).and_return('END')
    end

    it "should display the sprint name" do
      result = @it.sprint_header(@sprint)
      result.should include("#{@sprint.name}")
    end

    it "should display the date if asked to" do
      @it.sprint_header(@sprint, :show_date? => true).should include('<small>START to END</small>')
    end
  end
end

