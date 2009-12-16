module Broach
  class Session
    include Broach::Attributes
    
    # Returns true when the connection should use SSL and false otherwise.
    def use_ssl?
      @attributes['use_ssl'] || false
    end
    
    def scheme
      use_ssl? ? 'https' : 'http'
    end
    
    def fetch(path)
      url      = ["#{scheme}:/", "#{account}.campfirenow.com", path].join('/')
      response = REST.get(url, {
        'Accept'     => 'application/json',
        'User-Agent' => 'Broach'
      }, {
        :username => token, :password => 'x'
      })
      
      if response.ok?
        return JSON.parse(response.body) 
      elsif response.unauthorized?
        exception = ::Broach::AuthenticationError.new("Couldn't authenticate with the supplied credentials for the account `#{account}'")
      elsif response.forbidden?
        exception = ::Broach::AuthorizationError.new("Couldn't fetch the resource `#{path}' on the account `#{account}'")
      else
        exception = ::Broach::APIError.new("Response from the server was unexpected (#{response.status_code})")
      end
      
      exception.response = response
      raise exception
    end
  end
end