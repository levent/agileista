require File.dirname(__FILE__) + '/../spec_helper'
require 'digest/sha1'

describe Person do
  
  before(:each) do
    @it = Person.new
  end

  # validates_confirmation_of :password
  # validates_length_of :password, :in => 6..16, :if => :password_required?
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  # validates_uniqueness_of :email, :scope => :account_id
  it { should belong_to :account }
  it { should have_many :user_stories }

  it "should have unique email addresses per account" do
    account = Account.make
    person1 = Person.make(:account => account)
    person2 = Person.make(:email => person1.email)
    lambda { Person.make(:account => account, :email => person1.email) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has already been taken")
  end

  describe "#validate_account" do
    it "should person to authenticated" do
      @it.should_not be_authenticated
      @it.validate_account
      @it.should be_authenticated
    end
  end

  describe "account_holder" do
    before(:each) do
      @account = Account.make
    end

    it "should return true if person is account holder" do
      @it.account = @account
      @it.should_not be_account_holder
      @account.account_holder = @it
      @account.save!
      @it.should be_account_holder
    end

    it "should allow user deletion" do
      @it.account = @account
      @it.should_not be_can_delete_users
      @account.account_holder = @it
      @account.save!
      @it.should be_can_delete_users
    end
  end

  describe "in general" do
    it "should have a hashed_password field" do
      @it.respond_to?(:hashed_password).should be_true
    end
    
    it "should have a salt field" do
      @it.respond_to?(:salt).should be_true
    end
    
    it "should require a password of min length 6" do
      @it.save.should be_false
      @it.errors.on(:password).should == 'is too short (minimum is 6 characters)'
    end
    
    it "should require a password only if none is set" do
      @it.password = 'shortpass'
      @it.password_confirmation = 'shortpass'
      @it.name = "Monkey man"
      @it.email = "me@example.com"
      @it.account_id = 197
      @it.save
      @it.reload
      @it = Person.find(@it.id)
      @it.password.should be_nil
      @it.hashed_password.should_not be_nil
      @it.save.should be_true
    end
  end
  
  describe '#encrypt' do
    it "should encrypt passed in password" do
      @it.salt = 'saltydog'
      Digest::SHA1.should_receive(:hexdigest).with("saltydog--monkey").and_return('cool')
      @it.encrypt('monkey').should == 'cool'
    end
  end
  
  describe '#generate_temp_password' do
    it "should set a password and return it" do
      @it.email = 'abc@example.com'
      @it.name = "name"
      @it.account_id = 99
      pass = @it.generate_temp_password
      @it.save.should be_true
      @it.reload
      @it.encrypt(pass).should == @it.hashed_password
    end
  end
  
  describe 'check hashed_password works' do
    it "should log user in" do
      @it.name = "Name of me"
      @it.email = "email@example.com"
      @it.password = "m3t00!"
      @it.account_id = 103
      @it.hashed_password.should be_blank
      @it.save
      @it.hashed_password.should == Digest::SHA1.hexdigest("#{@it.salt}--m3t00!")
    end
  end
  
  describe "#hash_password" do
    it "should set hashed_password and salt" do
      @it.password = "monkeyface"
      Timecop.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").and_return('salted')
        Digest::SHA1.should_receive(:hexdigest).with("salted--monkeyface").and_return('hashed')
        @it.hash_password
      end
      @it.hashed_password.should == 'hashed'
      @it.salt.should == 'salted'
    end
    
    it "should not set salt unless new record" do
      @it.stub!(:new_record?).and_return(false)
      @it.salt = "salted"
      @it.password = "monkeyface"
      Timecop.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").exactly(0).times
        Digest::SHA1.should_receive(:hexdigest).with("salted--monkeyface").and_return('hashed')
        @it.hash_password
      end
      @it.hashed_password.should == 'hashed'
    end
    
    it "should set salt if not new record but no salt" do
      @it.stub!(:new_record?).and_return(false)
      @it.password = "monkeyface"
      Timecop.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").and_return('salted')
        Digest::SHA1.should_receive(:hexdigest).with("salted--monkeyface").and_return('hashed')
        @it.hash_password
      end
      @it.hashed_password.should == 'hashed'
    end
    
    it "should not do anything if password not passed" do
      Timecop.freeze do
        Digest::SHA1.should_receive(:hexdigest).with("#{Time.now}--somecrazyrandomstring").exactly(0).times
        Digest::SHA1.should_receive(:hexdigest).with("salted--monkeyface").exactly(0).times
        @it.hash_password.should be_nil
      end
    end
    
    it "should be called on save if valid" do
      @it.stub!(:valid?).and_return(true)
      @it.should_receive(:hash_password)
      @it.save
    end
    
    it "should NOT be called on save if invalid" do
      @it.stub!(:valid?).and_return(false)
      @it.should_receive(:hash_password).exactly(0).times
      @it.save
    end
  end
end
