Feature:
In order to login
I want a working login form

Background:
  Given the domain "test.example.com"
  And the following people:
    | name     | email      | authenticated | password |
    | levent   | me@you.com | 1             | mypass   |

Scenario: Login
  When I go to "the login page"
  Then I should see "Login"
  And I fill in "email" with "me@you.com"
  And I fill in "password" with "mypass"
  And I press "Login"
  Then I should see "You have logged in successfully"

Scenario: Forgot password
  Given I go to "the login page"
  And I follow "I forgot my password"
  When I fill in "email" with "me@you.com"
  And I press "Send password"
  Then I should see "Please check your email for your new password"
  