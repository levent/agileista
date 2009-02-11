require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  it {should validate_presence_of(:name)}
  
  it "should have a unique name" do
    Account.create(:subdomain => 'valid', :name => 'valid')
    should validate_uniqueness_of(:name)
  end
  
  it "should have a unique subdomain" do
    Account.create(:subdomain => 'valid', :name => 'valid')
    should validate_uniqueness_of(:subdomain)
  end
  
  it {should have_many(:impediments)}

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