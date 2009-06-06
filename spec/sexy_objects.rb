def create_account
  Account.create!(:name => "sexy_dev_team", :subdomain => "xxx", :iteration_length => 2)
end