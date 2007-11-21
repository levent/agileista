require File.dirname(__FILE__) + '/../test_helper'

class SprintTest < Test::Unit::TestCase
  fixtures :sprints, :accounts, :user_stories

  # Replace this with your real tests.
  def test_belongs_to_account
    assert create_sprint.valid?
  end
  
  def test_must_have_account
    s = create_sprint(:account => nil)
    s.save
    assert_equal false, s.valid?
    assert s.errors.on(:account)
  end
  
  def test_must_have_start_end_date
    s = create_sprint(:start_at => nil, :end_at => nil)
    assert s.errors.on(:start_at)
    assert s.errors.on(:end_at)
    s.start_at = 6.days.ago
    s.end_at = 6.days.from_now
    s.save
    assert_equal true, s.valid?
    # s = create_sprint(:start_at => 6.days.ago, :end_at => 6.days.from_now)
  end
  
  def test_has_many_user_stories
    s = create_sprint
    assert_equal true, s.respond_to?("user_stories")
    s.user_stories << UserStory.find(:first)
    
  end
  
  # def test_list
  #   s = create_sprint
  #   t = create_sprint
  #   assert_equal s.position + 1, t.position
  #   s2 = create_sprint(:account => Account.find(2))
  #   assert_not_equal s.position + 2, s2.position
  # end
  
  private
  
  def create_sprint(options = {})
    Sprint.create({:start_at => 6.days.ago, :end_at => 6.days.from_now, :account => Account.find(:first)}.merge(options))
  end
end
