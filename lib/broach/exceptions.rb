module Broach
  # Raised when something unexpected happened during communication with Campfire
  class APIError < RuntimeError
    attr_accessor :response
  end
  
  # Raised when the credentials were incorrect
  class AuthenticationError < APIError; end
  
  # Raised when the credentials were correct, but the resource could not be accessed
  class AuthorizationError < APIError; end
  
  # Raised when the configuration of the account was incorrect
  class ConfigurationError < APIError; end
end