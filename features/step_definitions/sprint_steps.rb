Given /^the following active sprints:$/ do |sprints|
  sprints.hashes.each do |sprint|
    account = Account.find_by_name(sprint[:account])
    Sprint.make(:account => account, :name => sprint[:name])
  end
end
