require File.dirname(__FILE__) + '/../../test_helper'
require 'project/tasks_controller'

# Re-raise errors caught by the controller.
class Project::TasksController; def rescue_action(e) raise e end; end

class Project::TasksControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::TasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
