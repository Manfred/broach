module Broach
  # Makes a very simple attribute driven model from the class when included.
  module Attributes
    def initialize(attributes)
      @attributes = attributes
    end
    
    def id; @attributes['id']; end
    
    def method_missing(method, *arguments, &block)
      if value = @attributes[method.to_s]
        value
      else
        super
      end
    end
  end
end