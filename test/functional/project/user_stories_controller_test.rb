require File.dirname(__FILE__) + '/../../test_helper'
require 'project/user_stories_controller'

# Re-raise errors caught by the controller.
class Project::UserStoriesController; def rescue_action(e) raise e end; end

class Project::UserStoriesControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::UserStoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
