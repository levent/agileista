class AddDeviseIndeces < ActiveRecord::Migration
  def up
    add_index :people, :email,                :unique => true
    add_index :people, :reset_password_token, :unique => true
    add_index :people, :authentication_token, :unique => true
    add_index :people, :confirmation_token,   :unique => true
  end

  def down
    remove_index :people, :email
    remove_index :people, :reset_password_token
    remove_index :people, :authentication_token
    remove_index :people, :confirmation_token
  end
end
