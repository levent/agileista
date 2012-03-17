# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_agileista_session',
  :secret      => '5779820f72ee8ba893a0bbf5b5aec30dfe190c6d7dbd334e8f52d7b903eafb50dc7589c86987ead0b396f603b1205b93b313bfe3b12ded8f4e0812a4df4b344b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
