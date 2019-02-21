require 'test_helper'

class ErrorTest < Minitest::Test
  def error_response
    Gillbus::SessionLogin::Response.parse_string(File.read('test/responses/error.xml'))
  end

  def malformed_response
    Gillbus::SessionLogin::Response.parse_string('not an xml')
  end

  def malformed_response_2
    Gillbus::SessionLogin::Response.parse_string('<NOTDATA></NOTDATA>')
  end

  def test_errorness
    assert error_response.error?
    assert_equal 4, error_response.error_code
    assert_equal 'Session not created error!', error_response.error_message
    assert_equal "We'r fucked", error_response.external_error_message
  end

  def test_malformed_errorness
    assert malformed_response.error?
    assert malformed_response.error_message.include?("Malformed response: invalid format")
  end

  def test_malformed_2_errorness
    assert malformed_response_2.error?
  end
end
