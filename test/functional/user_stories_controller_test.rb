require File.dirname(__FILE__) + '/../test_helper'
require 'user_stories_controller'

# Re-raise errors caught by the controller.
class UserStoriesController; def rescue_action(e) raise e end; end

class UserStoriesControllerTest < Test::Unit::TestCase
  def setup
    @controller = UserStoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
