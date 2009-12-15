module Broach
  module AttributeInitializer
    def initialize(attributes)
      attributes.each do |key, value|
        accessor = "#{key}="
        if respond_to?(accessor)
          send(accessor, value)
        else
          raise ArgumentError, "Unknown setting `#{key}'"
        end
      end
    end
  end
end