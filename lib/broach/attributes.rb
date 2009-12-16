module Broach
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