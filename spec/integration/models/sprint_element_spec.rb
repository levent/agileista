require 'spec_helper'

describe SprintElement do
  context "auditing" do
    before do
      sweeper = mock(SprintAuditSweeper)
      sweeper.stub!(:update)
      SprintElement.instance_variable_set(:@observer_peers, [sweeper])
      @project = Project.make!(:name => "sexy_dev_team", :iteration_length => 2)
      @sprint = Sprint.create!(:project => @project, :start_at => 3.days.ago, :name => "Fluff")
      @us = UserStory.create!(:project => @project, :definition => "As a user I'd like some fluffing")
      @sprint_element = SprintElement.create!(:sprint => @sprint, :user_story => @us)
      @person = Person.create!(:name => "schlong", :password => "password", :email => "person@here.com")
      @project.people << @person
    end

    describe "audit on create" do  
      it "should create a major Sprint Change if sprint is live" do
        @sprint.current?.should be_true
        lambda{@sprint_element.audit_create(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_true
        audit.kind.should == "create"
        audit.details.should == "User story added by schlong"
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
        audit.details.should == "User story added by schlong"
        audit.person.should == @person
      end

      it "not bork" do
        SprintChange.stub(:create).and_raise NoMethodError
        lambda { @sprint_element.audit_create(nil) }.should_not raise_error
      end
    end

    describe "audit on update" do
      it "should create a major Sprint Change if sprint is live" do
        @sprint.current?.should be_true
        lambda{@sprint_element.audit_update(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_true
        audit.kind.should == "update"
        audit.details.should == "User story changed by schlong"
        audit.person.should == @person
      end

      it "should create a minor Sprint Change if sprint is not live" do
        @sprint.end_at = 1.day.ago
        @sprint.save!
        @sprint.current?.should be_false
        @sprint_element.reload
        lambda{@sprint_element.audit_update(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_false
        audit.kind.should == "update"
        audit.details.should == "User story changed by schlong"
        audit.person.should == @person
      end

      it "not bork" do
        SprintChange.stub(:create).and_raise NoMethodError
        lambda { @sprint_element.audit_update(nil) }.should_not raise_error
      end
    end

    describe "audit on destroy" do  
      it "should create a major Sprint Change if sprint is live" do
        @sprint.current?.should be_true
        lambda{@sprint_element.audit_destroy(@person)}.should change(SprintChange, :count).by(1)
        audit = SprintChange.last
        audit.major.should be_true
        audit.kind.should == "destroy"
        audit.details.should == "User story removed by schlong"
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
        audit.details.should == "User story removed by schlong"
        audit.person.should == @person
      end

      it "not bork" do
        SprintChange.stub(:create).and_raise NoMethodError
        lambda { @sprint_element.audit_destroy(nil) }.should_not raise_error
      end
    end

  end
end
