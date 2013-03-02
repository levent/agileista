require 'spec_helper'

describe ConsoleHelper do
  include ConsoleHelper

  before(:each) do
    @it = helper
  end

  describe "#show_account_holder" do
    it "should say if none" do
      @it.show_account_holder(Account.new).should == "NO ACCOUNT HOLDER"
    end

    it "should give info on account_holder" do
      account = Account.new(:account_holder => Person.make)
      @it.show_account_holder(account).should == "#{account.account_holder.name} (#{account.account_holder.email})"
    end

  end
end
