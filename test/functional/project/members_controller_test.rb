require File.dirname(__FILE__) + '/../../test_helper'
require 'project/members_controller'

# Re-raise errors caught by the controller.
class Project::MembersController; def rescue_action(e) raise e end; end

class Project::MembersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::MembersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
