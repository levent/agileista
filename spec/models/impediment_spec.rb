require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Impediment do
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:person_id)}
  it {should validate_presence_of(:account_id)}
  it {should belong_to(:team_member)}
  it {should belong_to(:account)}
  
  before(:each) do
    @it = Impediment.new
  end
  
  describe "resolve!" do
    it "should try and set the resolved_at time and save" do
      Timecop.freeze do
        @it.should_receive(:resolved_at=).with(Time.now)
        @it.should_receive(:save).and_return('tru')
        @it.resolve!.should == 'tru'
      end
    end
  end
  
  describe '#to_s' do
    describe 'when summary is Active' do
      it "should show something useful" do
        Timecop.freeze do
          @it.stub!(:new_record?).and_return(false)
          @it.stub!(:created_at).and_return(Time.now)
          @it.to_s.should == "Active since #{Time.now.strftime('%T %d/%m/%y')}"
        end
      end
    end
    
    describe 'when summary is Resolved' do
      it "should show something useful" do
        Timecop.freeze do
          @it.stub!(:new_record?).and_return(false)
          @it.stub!(:resolved_at).and_return(Time.now)
          @it.to_s.should == "Resolved at #{Time.now.strftime('%T %d/%m/%y')}"
        end
      end
    end
    
    describe 'when item is new' do
      it "should show description" do
        @it.to_s.should == @it.description
      end
      
      it "should show description when present" do
        @it.description = "Awesome"
        @it.to_s.should == @it.description
      end
    end
  end
  
  describe "named_scope(s)" do
    describe "unresolved" do
      it "should correctly generate conditions for unresolved impediments" do
        Impediment.unresolved.proxy_options.should == {:conditions=>{:resolved_at=>nil}}
        Account.new.impediments.unresolved.proxy_options.should == {:conditions=>{:resolved_at=>nil}} # This test is a bit ugly and unneccessary?
      end
    end
  end
end
