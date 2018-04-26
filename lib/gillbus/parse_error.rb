# I want it not to be an exception, for now
class Gillbus::ParseError
  def initialize(response_string, error_message)
    @response = response_string
    @error_message = error_message
  end

  attr_reader :response
  attr_accessor :session_id
  attr_accessor :request_time
  def error?; true; end

  def error_code; 0; end

  def error_message
    "Malformed response: #{@error_message}"
  end
end
