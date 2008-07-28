require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @it = Account.new
  end

  describe "in general" do
    it "should have many impediments" do
      @it.should have_many(:impediments).with(:order => 'resolved_at, created_at DESC')
    end
    
    it "should require unique names" do
      @it.stub!(:valid?).and_return(true)
      @it.name = "unique"
      @it.save.should be_true
      @it.reload
      @account = Account.new(:name => 'unique')
      @account.valid?.should be_false
      @account.errors.on(:name).should == 'of account has already been taken'
    end
  end
end