require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AcceptanceCriterium do
  it {should belong_to(:user_story)}
  it {should validate_presence_of(:detail)}
end

