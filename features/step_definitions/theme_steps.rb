Given /^the following themes:$/ do |table|
  table.hashes.each do |theme|
    account = Account.find_by_name(theme[:account])
    Theme.make(:account => account, :name => theme[:name])
  end
end
