# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_itlinux_session',
  :secret      => '4cb09d2528b2cde9c306e500406cd3534fd86eba12ec0581917fb722fd26d4ae590f07b48c54e3aba2d52d16be3ee9b482d2276994d63341acf23c906ec39a8d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
