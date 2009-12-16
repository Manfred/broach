module Broach
  # Represents a user on the server
  class User
    include Broach::Attributes
    
    # Returns a User instance for the currently authenticated user
    def self.me
      new(Broach.session.get('users/me')['user'])
    end
    
    # Returns a User instance for a user with a specific ID
    def self.find(id)
      new(Broach.session.get("users/#{id.to_i}")['user'])
    end
  end
end