require 'active_record'
require 'protected_attributes'
require 'unit_helper'
require 'project'
require 'console_helper'

describe ConsoleHelper do
  include ConsoleHelper

  describe "#show_account_holder" do
    before do
      @project = fire_double("Project")
      @project.stub(:scrum_master)
    end

    it "should say if none" do
      show_account_holder(@project).should == "NO ACCOUNT HOLDER"
    end

    it "should give info on scrum_master" do
      scrum_master = fire_double("Person")
      scrum_master.stub(:name).and_return("Fred")
      scrum_master.stub(:email).and_return("fred@example.com")
      @project.should_receive(:scrum_master).and_return(scrum_master)
      show_account_holder(@project).should == "Fred (fred@example.com)"
    end

  end
end
