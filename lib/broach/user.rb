module Broach
  class User
    include Broach::Attributes
    
    def self.me
      new(Broach.session.fetch('users/me')['user'])
    end
  end
end