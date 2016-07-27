require 'test_helper'

class SessionLoginTest < Minitest::Test

  def session_login
    Gillbus::SessionLogin::Response.parse_string(File.read('test/responses/sessionLogin.xml'))
  end

  def test_cities
    assert session_login.logged
  end
end
