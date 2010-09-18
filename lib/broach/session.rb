module Broach
  # Represents a session with Campfire
  class Session
    include Broach::Attributes
    
    # Returns true when the connection should use SSL and false otherwise.
    def use_ssl?
      @attributes['use_ssl'] || false
    end
    
    # Returns either http or https depending on whether we should use SSL or not.
    def scheme
      use_ssl? ? 'https' : 'http'
    end
    
    # Returns the full URL for a certain path
    #
    #   session.url_for('rooms') #=> "http://example.campfirenow.com/rooms"
    def url_for(path)
      ["#{scheme}:/", "#{account}.campfirenow.com", path].join('/')
    end
    
    # Returns the headers to send for a specific HTTP method
    #
    #   session.headers_for(:get) #=> { 'Accept' => 'application/json' }
    def headers_for(method)
      headers = { 'Accept' => 'application/json', 'User-Agent' => 'Broach' }
      headers['Content-type'] = 'application/json' if method == :post
      headers
    end
    
    # Returns the credentials to authenticate the current user
    def credentials
      { :username => token, :password => 'x' }
    end
    
    # Gets a resource with a certain path on the server. When the GET is succesful
    # the parsed body is returned, otherwise an exception is raised.
    def get(path)
      response = REST.get(url_for(path), headers_for(:get), credentials)
      if response.ok?
        JSON.parse(response.body)
      else
        handle_response(:get, path, response)
      end
    end
    
    # Posts a resource to a certain path on the server. When the POST is successful
    # the parsed body is returned, otherwise an exception is raised.
    def post(path, payload)
      response = REST.post(url_for(path), payload.to_json, headers_for(:post), credentials)
      if response.created?
        JSON.parse(response.body)
      else
        handle_response(:post, path, response)
      end
    end
    
    private
    
    def handle_response(method, path, response)
      exception = if response.unauthorized?
        Broach::AuthenticationError.new("Couldn't authenticate with the supplied credentials for the account `#{account}'")
      elsif response.forbidden?
        Broach::AuthorizationError.new("Couldn't #{method.to_s.upcase} the resource `#{path}' on the account `#{account}'")
      elsif response.found?
        Broach::ConfigurationError.new("Got redirected when trying to #{method.to_s.upcase} the resource `#{path}' on the account `#{account}'")
      else
        Broach::APIError.new("Response from the server was unexpected (#{response.status_code})")
      end
      exception.response = response
      raise exception
    end
  end
end