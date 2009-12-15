require File.expand_path('../../start', __FILE__)

class AuthentiationTest < Test::Unit::TestCase
  def test_authenticates_with_proper_credentials
    session = Broach::Session.new(settings)
    assert session.me.has_key?('user')
  end
  
  def test_raises_authentication_error_with_improper_credentials
    session = Broach::Session.new(settings.merge('token' => 'wrong'))
    begin
      session.me.has_key?('user')
    rescue Broach::AuthenticationError => e
      assert_not_nil e.response
      assert e.response.unauthorized?
    end
  end
  
  def test_raises_authorization_error_when_accessing_an_unauthorized_resource
  end
  
  def test_raises_general_api_error_when_something_unexpected_happened
  end
end