require 'spec_helper'

describe Person do
  before(:each) do
    @it = Person.new
  end

  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should have_many :projects }
  it { should have_many :user_stories }
end
