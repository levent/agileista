class DropBetaEmails < ActiveRecord::Migration
  def change
    drop_table :beta_emails
  end
end
