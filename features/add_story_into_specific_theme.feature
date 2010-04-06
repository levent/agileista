Feature: Add story from themes
  In order to quickly add stories into a specific theme
  As a team member
  I want be able to add stories directly to the theme from the themes page

Background:
  Given the following accounts:
    | name   |
    | levent |
  Given the following themes:
    | account | name        |
    | levent  | New hotness |
  And I sign in as team member "levent@example.com" to an account "levent"

  Scenario: Navigate and add a story to a theme
    Given follow "Themes"
    And I follow "New hotness"
    When I follow "add new user story"
    Then the "New hotness" checkbox should be checked
