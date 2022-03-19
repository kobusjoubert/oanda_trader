module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    # Set a cookie with the user id and verify that at the socket connection.
    # Cookie is set and destroyed in config/initializers/warden_hooks.rb
    def find_verified_user
      verified_user = User.find_by(id: cookies.signed['user_id'])

      if verified_user && cookies.signed['user_expires_at'] > Time.now
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
