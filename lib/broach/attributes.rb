module Broach
  # Makes a very simple attribute driven model from the class when included.
  module Attributes
    def initialize(attributes)
      @attributes = attributes
    end
    
    def id; @attributes['id']; end
    
    def method_missing(method, *arguments, &block)
      if key = method.to_s and @attributes.has_key?(key)
        @attributes[key]
      else
        super
      end
    end
  end
end