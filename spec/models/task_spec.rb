require File.dirname(__FILE__) + '/../spec_helper'

describe Task do
  
  before(:each) do
    @task = Task.new
  end
  
  describe "named_scopes" do
    describe "incomplete" do
      it "should get all incomplete tasks" do
        expected_options = { :conditions => "developer_id IS NULL && (hours > 0 OR hours IS NULL)" }
        assert_equal expected_options, Task.incomplete.proxy_options
      end
    end
    
    describe "inprogress" do
      it "should get all inprogress tasks" do
        expected_options = { :conditions => "(developer_id IS NOT NULL AND hours > 0) OR (developer_id IS NOT NULL AND hours IS NULL)" }
        assert_equal expected_options, Task.inprogress.proxy_options
      end
    end
    
    describe "complete" do
      it "should get all complete tasks" do
        expected_options = { :conditions => "hours = 0" }
        assert_equal expected_options, Task.complete.proxy_options
      end
    end
  end
end