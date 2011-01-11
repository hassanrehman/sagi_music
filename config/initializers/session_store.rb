# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sagi_music_session',
  :secret      => 'ede8c826ffa140ecd3c295df665c29acbbd79d69270ef282dc0e1e4e801860d078f9a7bc2fc3523f48c0b95d94c532e8e52e5c251e6f84e08115ed8b103b5e90'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
