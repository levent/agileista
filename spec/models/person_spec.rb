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
  
  describe "#hash_password" do
    it "should set hashed_password and salt" do
      @it.password = "monkeyface"
      Time.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").and_return('salted')
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--monkeyface").and_return('hashed')
        @it.hash_password
      end
      @it.hashed_password.should == 'hashed'
      @it.salt.should == 'salted'
    end
    
    it "should not set salt if new record" do
      @it.stub!(:new_record?).and_return(false)
      @it.password = "monkeyface"
      Time.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").exactly(0).times
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--monkeyface").and_return('hashed')
        @it.hash_password
      end
      @it.hashed_password.should == 'hashed'
    end
    
    it "should not do anything if password not passed" do
      Time.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").exactly(0).times
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--monkeyface").exactly(0).times
        @it.hash_password.should be_false
      end
    end
  end
end