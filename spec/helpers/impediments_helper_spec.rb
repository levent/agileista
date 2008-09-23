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
  
  describe '#impediment_nav' do
    it "should return link to active if action is index" do
      @it.impediment_nav('index').should == link_to("Active", active_impediments_path)
    end
    
    it "should return link to index if action is all" do
      @it.impediment_nav('active').should == link_to("All", impediments_path)
    end
  end
  
  describe '#impediment_feed' do
    it "should return auto link to active if action is active" do
      @it.impediment_feed('index').should == auto_discovery_link_tag(:atom, formatted_impediments_path(:format => :atom))
    end
    
    it "should return auto link to index if action is index" do
      @it.impediment_feed('active').should == auto_discovery_link_tag(:atom, formatted_active_impediments_path(:format => :atom))
    end
  end
  
  # def impediment_feed(action)
  #   return auto_discovery_link_tag(:atom, formatted_active_impediments_path(:format => :atom)) if action == "active"
  #   return auto_discovery_link_tag(:atom, formatted_impediments_path(:format => :atom)) if action == "index"
  # end
end