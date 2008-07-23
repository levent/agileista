require File.dirname(__FILE__) + '/../spec_helper'

describe Person do
  
  before(:each) do
    @it = Person.new
    # @task_a = Task.new
    # @task_b = Task.new
  end

  describe "in general" do
    it "should have a hashed_password field" do
      @it.respond_to?(:hashed_password).should be_true
    end
    
    it "should have a salt field" do
      @it.respond_to?(:salt).should be_true
    end
  end
end