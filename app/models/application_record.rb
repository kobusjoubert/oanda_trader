class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  attr_encrypted_options.merge!(default_encoding: 'm', algorithm: 'aes-256-gcm')
  # attr_encrypted_options.merge!(default_encoding: 'u', algorithm: 'aes-256-gcm')
end
