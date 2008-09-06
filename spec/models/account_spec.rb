require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @it = Account.new
  end

  describe "in general" do
    it "should have many impediments" do
      @it.should have_many(:impediments).with(:order => 'resolved_at, created_at DESC')
    end

    it "should require unique subdomains" do
      @it.stub!(:valid?).and_return(true)
      @it.subdomain = "unique"
      @it.save.should be_true
      @it.reload
      @account = Account.new(:subdomain => 'unique')
      @account.valid?.should be_false
      @account.errors.on(:subdomain).should == 'has already been taken'
    end
    
    it "should require unique names" do
      @it.stub!(:valid?).and_return(true)
      @it.name = "unique"
      @it.save.should be_true
      @it.reload
      @account = Account.new(:name => 'unique')
      @account.valid?.should be_false
      @account.errors.on(:name).should == 'has already been taken'
    end
    
    it "should require unique subdomain" do
      @it.stub!(:valid?).and_return(true)
      @it.subdomain = "unique"
      @it.save.should be_true
      @it.reload
      @account = Account.new(:name => 'something', :subdomain => 'unique')
      @account.valid?.should be_false
      @account.errors.on(:subdomain).should == 'has already been taken'
    end
    
    %w(name subdomain).each do |field|
      it "should require #{field}" do
        @it.should require_a(field.to_sym)
      end
      
      it "should require uniqueness of #{field} ignoring case" do
        @it.send("#{field.to_sym}=", "jgp")
        @it.name = 'blank' unless @it.name
        @it.subdomain = 'blank' unless @it.subdomain
        @it.save.should be_true
        @account2 = Account.new(field.to_sym => 'JGP')
        @account2.save.should be_false
        @account2.errors.on(field.to_sym).should == "has already been taken"      
      end
    end
    
    ["monkey balls"].each do |subdomain|
      it "should not validate subdomain '#{subdomain}'" do
        @it.subdomain = subdomain
        @it.valid?.should be_false
        p @it.errors.on(:subdomain)
      end
    end
  end
  
  describe '#authenticate' do
    it "should log people in using their hashed_password" do
      @person = Person.new(:hashed_password => Digest::SHA1.hexdigest("salt--password"), :salt => 'salt')
      @it.people.should_receive(:find_by_email_and_authenticated_and_activation_code).with('someone@example.com', 1, nil).exactly(2).times.and_return(@person)
      @it.authenticate('someone@example.com', 'password').should == @person
      @it.authenticate('someone@example.com', '!password').should be_nil
    end
  end
  
  
  
  describe '#basic_authenticate' do
    it "should log people in using their hashed_password" do
      # Person.should_receive.find_by_email('me@example.com').and_return(@it)
      # @it.should_receive
      #         # Person.basic_authenticate('me@example.com', 'mypass')
    end
  end
end