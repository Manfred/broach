module Broach
  class User
    include Broach::Attributes
    
    def self.me
      new(Broach.session.get('users/me')['user'])
    end
    
    def self.find(id)
      new(Broach.session.get("users/#{id.to_i}")['user'])
    end
  end
end