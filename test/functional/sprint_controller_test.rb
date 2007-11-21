require File.dirname(__FILE__) + '/../test_helper'
require 'sprint_controller'

# Re-raise errors caught by the controller.
class SprintController; def rescue_action(e) raise e end; end

class SprintControllerTest < Test::Unit::TestCase
  def setup
    @controller = SprintController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
