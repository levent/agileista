require 'spec_helper'

describe SprintChange do
  it {should belong_to(:sprint)}
  it {should belong_to(:person)}
  it {should validate_presence_of(:sprint_id)}
end
