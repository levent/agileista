class AddSubdomainToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :subdomain, :string
  end

  def self.down
    remove_column :accounts, :subdomain
  end
end
