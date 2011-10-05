require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  it {should validate_presence_of(:name)}

  it {should have_many(:people).dependent(:destroy)}
  it {should have_many(:team_members).dependent(:destroy)}
  it {should have_many(:contributors).dependent(:destroy)}
  it {should have_many(:sprints).dependent(:destroy)}
  it {should have_many(:user_stories).dependent(:destroy)}
  it {should have_many(:impediments).dependent(:destroy)}
  it {should have_many(:themes).dependent(:destroy)}

  it {should belong_to(:account_holder)}

  it "should have a unique name" do
    Account.create(:subdomain => 'valid', :name => 'valid')
    should validate_uniqueness_of(:name)
  end
  
  it "should have a unique subdomain" do
    Account.create(:subdomain => 'valid', :name => 'valid')
    should validate_uniqueness_of(:subdomain)
  end

  it "should lower case name and subdomain" do
    account = Account.create(:subdomain => 'vALId', :name => 'vALId')
    account.subdomain.should == 'valid'
    account.name.should == 'valid'
  end

  describe "in general" do    
    ["monkey balls", "c___c", "c_there", "^%", "-subdomain", "subdomain-"].each do |subdomain|
      it { should_not allow_value(subdomain).for(:subdomain).with_message('may only contain numbers and letters') }
    end

    ["hello", "nice-subdomain", "a-b", "ab"].each do |subdomain|
      it { should allow_value(subdomain).for(:subdomain) }
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

  context "velocity calculations" do
    before(:each) do
      @account = Account.make
    end

    describe "#average_velocity" do

      it "should return nil if no velocity" do
        @account.average_velocity.should be_nil
      end

      it "should return the average velocity" do
        @account.sprints.make(:end_at => 1.week.ago, :start_at => 2.weeks.ago, :velocity => 1)
        @account.sprints.make(:end_at => 2.week.ago, :start_at => 3.weeks.ago, :velocity => 32)
        @account.sprints.make(:end_at => 2.week.ago, :start_at => 3.weeks.ago, :velocity => 32)
        @account.sprints.make(:end_at => 2.week.ago, :start_at => 3.weeks.ago, :velocity => 32)
        @account.sprints.make(:end_at => 3.week.ago, :start_at => 4.weeks.ago, :velocity => 22)
        @account.average_velocity.should == 23
      end
    end

    describe "#median_velocity" do
      it "should return nil if no velocity" do
        @account.median_velocity.should be_nil
      end

      it "should return the median velocity" do
        @account.sprints.make(:end_at => 1.week.ago, :start_at => 2.weeks.ago, :velocity => 1)
        @account.sprints.make(:end_at => 2.week.ago, :start_at => 3.weeks.ago, :velocity => 32)
        @account.sprints.make(:end_at => 2.week.ago, :start_at => 3.weeks.ago, :velocity => 32)
        @account.sprints.make(:end_at => 2.week.ago, :start_at => 3.weeks.ago, :velocity => 32)
        @account.sprints.make(:end_at => 3.week.ago, :start_at => 4.weeks.ago, :velocity => 22)
        @account.median_velocity.should == 32
      end
    end
  end
end
