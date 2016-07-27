# I want it not to be an exception, for now
class Gillbus::ParseError
  def initialize(response_string)
    @response = response_string
  end
  attr_reader :response
  attr_accessor :session_id
  def error?; true; end
  def error_code; 0; end
  def error_message; "Malformed response"; end
end
