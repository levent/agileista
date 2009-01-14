require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImpedimentsHelper do
  include ImpedimentsHelper
  
  before(:each) do
    @it = self
  end  
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ImpedimentsHelper)
  end
  
  describe '#impediment_feed' do
    it "should return auto link to active if action is active" do
      @it.impediment_feed('index').should == auto_discovery_link_tag(:atom, formatted_impediments_path(:format => :atom))
    end
    
    it "should return auto link to index if action is index" do
      @it.impediment_feed('active').should == auto_discovery_link_tag(:atom, formatted_active_impediments_path(:format => :atom))
    end
  end
end