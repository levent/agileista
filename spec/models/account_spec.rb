require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  it {should validate_presence_of(:name)}
  
  describe "#velocity" do
    # describe "no iterations complete" do
    #   it "should be zero" do
    #     account = Account.new(:name => 'a', :subdomain => 'abcdef')
    #     account.calculated_velocity.should == 0
    #     account.velocity.should == 0
    #   end
    # end

    # describe "with iterations" do
    #   before(:each) do
    #     sprint1 = Sprint.new
    #     sprint2 = Sprint.new
    #     sprint3 = Sprint.new
    #     sprint4 = Sprint.new
    #     sprint5 = Sprint.new
    #     sprint6 = Sprint.new
    #     sprint7 = Sprint.new
    #     sprint8 = Sprint.new
    #   
    #     sprint1.stub!(:velocity).and_return(200000)
    #     sprint2.stub!(:velocity).and_return(20000000)
    #     sprint3.stub!(:velocity).and_return(2300)
    #     sprint4.stub!(:velocity).and_return(23)
    #     sprint5.stub!(:velocity).and_return(23)
    #     sprint6.stub!(:velocity).and_return(23)
    #     sprint7.stub!(:velocity).and_return(23)
    #     sprint8.stub!(:velocity).and_return(23)
    #   
    #     sprint1.stub!(:finished?).and_return(false)
    #     sprint2.stub!(:finished?).and_return(false)
    #     sprint3.stub!(:finished?).and_return(false)
    #     sprint4.stub!(:finished?).and_return(true)
    #     sprint5.stub!(:finished?).and_return(true)
    #     sprint6.stub!(:finished?).and_return(true)
    #     sprint7.stub!(:finished?).and_return(true)
    #     sprint8.stub!(:finished?).and_return(true)
    #   
    #     @account = Account.new(:name => 'a', :subdomain => 'abcdef')
    #     @account.stub!(:sprints).and_return([sprint1, sprint2, sprint3, sprint4, sprint5, sprint6, sprint7, sprint8])
    #   end
    # 
    #   it "should tally up all finished sprint' velocities and get the average" do
    #     @account.calculated_velocity.should == 23
    #     @account.velocity.should == 23
    #   end
    # end
  end
  
  it "should have a unique name" do
    Account.create(:subdomain => 'valid', :name => 'valid')
    should validate_uniqueness_of(:name)
  end
  
  it "should have a unique subdomain" do
    Account.create(:subdomain => 'valid', :name => 'valid')
    should validate_uniqueness_of(:subdomain)
  end
  
  it {should have_many(:impediments).dependent(:destroy)}
  it {should have_many(:themes).dependent(:destroy)}
  it {should have_many(:releases).dependent(:destroy)}
  it {should have_many(:tags).dependent(:destroy)}
  it {should have_many(:people).dependent(:destroy)}
  it {should have_many(:sprints).dependent(:destroy)}
  it {should have_many(:user_stories).dependent(:destroy)}

  describe "in general" do    
    ["monkey balls", "c___c", "c_there", "^%"].each do |subdomain|
      it { should_not allow_value(subdomain).for(:subdomain).with_message('may only contain numbers and letters') }
    end
  end
  
  describe '#authenticate' do
    before(:each) do
      @it = Account.new(:subdomain => 'valid', :name => 'valid')
    end
    
    it "should log people in using their hashed_password" do
      @person = Person.new(:hashed_password => Digest::SHA1.hexdigest("salt--password"), :salt => 'salt')
      @it.people.should_receive(:find_by_email_and_authenticated_and_activation_code).with('someone@example.com', 1, nil).exactly(2).times.and_return(@person)
      @it.authenticate('someone@example.com', 'password').should == @person
      @it.authenticate('someone@example.com', '!password').should be_nil
    end
  end
end