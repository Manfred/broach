module Broach
  class User
    include Broach::Attributes
    
    def self.me
      new(Broach.session.fetch('users/me')['user'])
    end
    
    def self.find(id)
      new(Broach.session.fetch("users/#{id.to_i}")['user'])
    end
  end
end