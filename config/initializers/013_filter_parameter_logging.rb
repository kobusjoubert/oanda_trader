# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :access_token, :access_token_iv, :encrypted_access_token, :encrypted_access_token_iv]
