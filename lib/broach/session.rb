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
    
    def url_for(path)
      ["#{scheme}:/", "#{account}.campfirenow.com", path].join('/')
    end
    
    def headers_for(method)
      headers = { 'Accept' => 'application/json', 'User-Agent' => 'Broach' }
      headers['Content-type'] = 'application/json' if method == :post
      headers
    end
    
    def credentials
      { :username => token, :password => 'x' }
    end
    
    def get(path)
      response = REST.get(url_for(path), headers_for(:get), credentials)
      if response.ok?
        return JSON.parse(response.body)
      else
        handle_response(:get, path, response)
      end
    end
    
    def post(path, payload)
      response = REST.post(url_for(path), JSON.dump(payload), headers_for(:post), credentials)
      if response.created?
        return JSON.parse(response.body)
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
      else
        Broach::APIError.new("Response from the server was unexpected (#{response.status_code})")
      end
      exception.response = response
      raise exception
    end
  end
end