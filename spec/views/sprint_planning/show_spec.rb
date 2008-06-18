require File.dirname(__FILE__) + '/../../spec_helper'

describe "sprint_planning/show" do
  before(:each) do
    @us1 = UserStory.new(:definition => 'user story A')
    @us2 = UserStory.new(:definition => 'user story B')
    assigns[:sprint] = Sprint.new(:name => 'Sprint A')
    assigns[:sprint].user_stories = [@us1, @us2]
    assigns[:user_stories] = []
  end
  
  it "should class planned user_stories according to whether they are tasked or not" do
    template.should_receive(:tasked?).with(@us1).and_return(' defined')
    template.should_receive(:tasked?).with(@us2).and_return(' undefined')
    render "sprint_planning/show"
    response.should have_tag 'div#committed' do
      with_tag 'div[class=?]', 'notecard defined', /user story A/
      with_tag 'div[class=?]', 'notecard undefined', /user story B/
    end
  end
end