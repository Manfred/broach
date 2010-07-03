module Broach
  # Represents a chat room on the server
  class Room
    TYPE_MAP = {
      :text  => 'TextMessage',
      :paste => 'PasteMessage',
      :sound => 'SoundMessage',
      :tweet => 'TweetMessage'
    }
    
    include Broach::Attributes
    
    # Send a message to the room
    #
    # ==== Parameters and options
    #
    # [+content+]
    #   Content to send. For a normal text message this is the content of the message. For a paste
    #   it's the content of the paste. For a sound it's the name of the sound.
    #
    # [<tt>:type</tt>]
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
        'body' => friendly_coerce_to_string(content)
      })['message']
    end
    
    # Sends a sound to the room
    #
    # This is basically a shortcut for speak(name, :type => :sound)
    def sound(name)
      speak(name, :type => :sound)
    end
    
    # Sends a paste to the room
    #
    # This is basically a shortcut for speak(content, :type => :paste)
    def paste(content)
      speak(content, :type => :paste)
    end
    
    private
    
    def friendly_coerce_to_string(content)
      if content.respond_to?(:join)
        content.join(' ')
      else
        content.to_s
      end
    end
    
    # Returns a Room instance for all rooms accessible to the authenticated user
    def self.all
      Broach.session.get('rooms')['rooms'].map do |attributes|
        Broach::Room.new(attributes)
      end
    end
    
    # Returns a Room instance for a room with a specific ID, raises an exception when it
    # can't find the room.
    def self.find(id)
      new(Broach.session.get("room/#{id.to_i}")['room'])
    end
    
    # Returns a Room instance for a room with a specific name, returns nil when it can't find
    # the room.
    def self.find_by_name(name)
      all.find { |room| room.name == name }
    end
  end
end