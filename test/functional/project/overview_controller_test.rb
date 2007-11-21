require File.dirname(__FILE__) + '/../../test_helper'
require 'project/overview_controller'

# Re-raise errors caught by the controller.
class Project::OverviewController; def rescue_action(e) raise e end; end

class Project::OverviewControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::OverviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
