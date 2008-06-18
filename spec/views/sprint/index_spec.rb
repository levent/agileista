require File.dirname(__FILE__) + '/../../spec_helper'

describe "sprint/index" do
  before(:each) do
    @us1 = UserStory.new(:definition => 'user story A')
    @us2 = UserStory.new(:definition => 'user story B')
    assigns[:current_sprint] = Sprint.new(:name => 'Sprint 1', :start_at => 1.weeks.ago, :end_at => 1.weeks.from_now)
    assigns[:user_stories] = [@us1, @us2]
    assigns[:incomplete] = []
    assigns[:inprogress] = []
    assigns[:complete] = []
  end
  
  it "should wrap user_story list items with appropriate class" do
    template.should_receive(:claimed_or_complete?).with(@us1).and_return(' class="leventa"')
    template.should_receive(:claimed_or_complete?).with(@us2).and_return(' class="leventb"')
    render "sprint/index"
    response.should have_tag('ul') do
      with_tag 'li>span[class=leventa]', /user story A/
      with_tag 'li>span[class=leventb]', /user story B/
    end
  end
end