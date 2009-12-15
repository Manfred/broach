module Broach
  class Room
    attr_accessor :session, :room_id
    include Broach::AttributeInitializer
  end
end