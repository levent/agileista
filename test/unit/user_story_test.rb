require File.dirname(__FILE__) + '/../test_helper'

class UserStoryTest < Test::Unit::TestCase
  fixtures :user_stories, :sprints, :projects

  # Replace this with your real tests.
  def test_belongs_to_sprint
    us = UserStory.find(:first)
    assert_equal true, us.respond_to?("sprint")
    us.sprint = Sprint.find(:first)
    us.project = Project.find(:first)
    us.definition = "something"
    us.save
    assert_equal Sprint, us.sprint.class
    # puts us.inspect
    assert us.valid?
    us.reload
    # assert_equal Sprint.find(:first), UserStory.find(:all).last.sprint
    
    assert_equal Sprint.find(:first), us.sprint
  end
end
