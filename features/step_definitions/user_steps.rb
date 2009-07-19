Given /^I sign in as team member "([^\"]*)" to an account "([^\"]*)"$/ do |email, name|
  account = Account.find_by_name(name)
  team_member = TeamMember.make(:account => account, :email => email)
  team_member.validate_account
  Given "I get to \"the login page\" for \"#{name}\""
  And "I fill in \"email\" with \"#{email}\""
  And "I fill in \"password\" with \"password\""
  And "I press \"Login\""
end
