Given /^the following accounts:$/ do |accounts|
  accounts.hashes.each do |account|
    Account.make(:name => account[:name], :subdomain => account[:name])
  end
end

Given /^I get to "([^\"]*)" for "([^\"]*)"$/ do |page_name, account|
  host! "#{account}.agileista"
  visit path_to(page_name)
end
