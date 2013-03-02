require 'spec_helper'

describe UserStory do
  it {should validate_presence_of(:account_id)}
end
