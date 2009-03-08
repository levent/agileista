require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Theme do
  it {should belong_to(:account)}
  it {should validate_presence_of(:name)}
  
  describe "acts as list" do
    before(:each) do
      Theme.destroy_all
    end
    
    it "should increment on create" do
      Theme.create!(:name => "T1").position.should == 1
      Theme.create!(:name => "T2").position.should == 2
    end
  end
end