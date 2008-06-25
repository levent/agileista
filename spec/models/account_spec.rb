require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @it = Account.new
  end

  describe "in general" do
    it "should have many impediments" do
      @it.should have_many(:impediments)
    end
  end
end
