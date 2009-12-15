module Broach
  class APIError < RuntimeError
    attr_accessor :response
  end
  
  class AuthenticationError < APIError; end
  class AuthorizationError < APIError; end
end