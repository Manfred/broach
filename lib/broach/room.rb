module Broach
  class Room
    TYPE_MAP = {
      :text  => 'TextMessage',
      :paste => 'PasteMessage',
      :sound => 'SoundMessage'
    }
    
    include Broach::Attributes
    
    # Send a message to the room
    #
    # ==== Options
    #
    # [+:type+]
    #   The type of message to send, this is :text by default for normal text messages.
    #   You can also use :paste and :sound. Valid sound messages are 'rimshot', 'crickets',
    #   or 'trombone'.
    #
    # ==== Examples
    #
    #   room = Broach::Room.all.first
    #   room.speak("Let's review these figures.")
    #   room.speak("<code>$stderr.write('-')</code>", :type => :paste)
    #   room.speak("rimshot", :type => :sound)
    def speak(content, options={})
      options[:type] ||= :text
      Broach.session.post("room/#{id}/speak", 'message' => {
        'type' => TYPE_MAP[options[:type]],
        'body' => content
      })
    end
    
    def self.all
      Broach.session.get('rooms')['rooms'].map do |attributes|
        Broach::Room.new(attributes)
      end
    end
    
    def self.find(id)
      new(Broach.session.get("room/#{id.to_i}")['room'])
    end
  end
end