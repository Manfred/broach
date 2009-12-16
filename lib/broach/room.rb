module Broach
  class Room
    include Broach::Attributes
    
    def self.all
      Broach.session.fetch('rooms')['rooms'].map do |attributes|
        Broach::Room.new(attributes)
      end
    end
    
    def self.find(id)
      new(Broach.session.fetch("room/#{id.to_i}")['room'])
    end
  end
end