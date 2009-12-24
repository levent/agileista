Given /^the domain "([^\"]*)"$/ do |domain|
  host! domain
end


Given /^the following accounts:$/ do |accounts|
  accounts.hashes.each do |account|
    Account.make(:name => account[:name], :subdomain => account[:name])
  end
end

Given /^the following people:$/ do |people|
  account = Account.make(:subdomain => "test")
  Person.destroy_all
  person = Person.create!(people.hashes.first.merge(:account_id => account.id))
  person.validate_account
end

Given /^I get to "([^\"]*)" for "([^\"]*)"$/ do |page_name, account|
  host! "#{account}.example.com"
  visit path_to(page_name)
end
