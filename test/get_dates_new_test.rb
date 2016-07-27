require 'test_helper'

class GetDatesNewTest < Minitest::Test

  def get_dates_new_empty
    Gillbus::GetDatesNew::Response.parse_string(File.read('test/responses/very_empty.xml'))
  end

  def test_empty_response
    assert_equal [], get_dates_new_empty.items
  end
end
