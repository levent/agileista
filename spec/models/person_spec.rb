require 'rails_helper'

RSpec.describe Person, type: :model do
  before(:each) do
    @it = Person.new
  end

  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should have_many :projects }
  it { should have_many :user_stories }

  describe 'admin?' do
    let(:user) { Person.new }

    it "should be true if it's levent" do
      user.email = ENV['admin_email']
      expect(user.admin?).to be_truthy
    end

    it "should be false otherwise" do
      expect(user.admin?).to be_falsey
    end
  end
end
