require File.dirname(__FILE__) + '/../spec_helper'

describe SprintElement do
  context "auditing" do
    before(:each) do
      sweeper = mock_model(SprintAuditSweeper)
      sweeper.stub!(:update)
      SprintElement.instance_variable_set(:@observer_peers, [sweeper])
      @account = create_account
      @sprint = Sprint.create!(:account => @account, :start_at => 3.days.ago, :name => "Fluff")
      @us = UserStory.create!(:account => @account, :definition => "As a user I'd like some fluffing")
      @sprint_element = SprintElement.create!(:sprint => @sprint, :user_story => @us)
      @person = Person.create!(:account => @account, :name => "schlong", :password => "password", :email => "person@here.com")
    end
    
    describe "audit on create" do  
      it "should create a major Sprint Change if sprint is live" do
        @sprint.current?.should be_true
        lambda{@sprint_element.audit_create(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_true
        audit.kind.should == "create"
        audit.details.should == "User story ##{@us.id} added by schlong"
        audit.person.should == @person
      end
      
      it "should create a minor Sprint Change if sprint is not live" do
        @sprint.end_at = 1.day.ago
        @sprint.save!
        @sprint.current?.should be_false
        @sprint_element.reload
        lambda{@sprint_element.audit_create(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_false
        audit.kind.should == "create"
        audit.details.should == "User story ##{@us.id} added by schlong"
        audit.person.should == @person
      end
    end
    
    describe "audit on destroy" do  
      it "should create a major Sprint Change if sprint is live" do
        @sprint.current?.should be_true
        lambda{@sprint_element.audit_destroy(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_true
        audit.kind.should == "destroy"
        audit.details.should == "User story ##{@us.id} removed by schlong"
        audit.person.should == @person
      end
      
      it "should create a minor Sprint Change if sprint is not live" do
        @sprint.end_at = 1.day.ago
        @sprint.save!
        @sprint.current?.should be_false
        @sprint_element.reload
        lambda{@sprint_element.audit_destroy(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_false
        audit.kind.should == "destroy"
        audit.details.should == "User story ##{@us.id} removed by schlong"
        audit.person.should == @person
      end
      
    end

  end
end