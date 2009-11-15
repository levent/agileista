require File.dirname(__FILE__) + '/../spec_helper'

describe TaskDeveloper do
  context "associations" do
    it {should belong_to(:developer)}
    it {should belong_to(:task)}
  end
end
