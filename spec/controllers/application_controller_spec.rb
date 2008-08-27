require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationController do
  it "should filter passwords from the logs" do
    # filter_parameter_logging :password, :password_confirmation
    # this defines a :filter_parameters methods
    # which seems to be the only way to check that this option is turned on
    @controller.should respond_to(:filter_parameters)
    filtered = @controller.send(:filter_parameters, {"some" => {"password" => "and"}, "password_confirmation" => "should be filtered"})
    filtered.should == {"some" => {"password" => "[FILTERED]"}, "password_confirmation" => "[FILTERED]"}
  end
end