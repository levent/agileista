Feature: Add story from taskboard
  In order to quickly add adhoc tasks to the taskboard
  As a team member
  I want be able to add stories directly to the sprint from the taskboard

Background:
  Given the following accounts:
    | name     |
    | levent   |
  Given the following active sprints:
    | account   | name   |
    | levent    | alpha  |
  And I sign in as team member "levent@example.com" to an account "levent"
    
  Scenario: Add story directly to sprint from taskboard
    When I am on "the backlog page"
    And I follow "Task board"
    And I follow "Add story to sprint"
    And I fill in "Title" with "As a user I'd like to accomplish things"
    And I fill in "Story points" with "8"
    # And I fill in "additional_theme" with "theme"
    And I press "Add to task board"
    And I am on "the backlog page"
    And I follow "Task board"
    Then I should see "#1"
