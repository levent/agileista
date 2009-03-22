require File.dirname(__FILE__) + '/../spec_helper'

describe BetaEmail do
  it {should validate_presence_of(:email)}
end