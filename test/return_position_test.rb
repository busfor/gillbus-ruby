require 'test_helper'

class ReturnPositionTest < Minitest::Test
  def test_request
    request = Gillbus::ReturnPosition::Request.new(
      ticket_count: 1,
      system_numbers: [123456],
    )

    assert_equal({
      ticketCount: 1,
      systemNumber0: 123456,
    }, request.params)
  end

  def test_success_response
    assert success_response.return_positions.first.confirmation
  end

  def test_failure_response
    refute failure_response.return_positions.first.confirmation
  end

  private

  def success_response
    Gillbus::ReturnPosition::Response.parse_string(File.read('test/responses/returnPositionSuccess.xml'))
  end

  def failure_response
    Gillbus::ReturnPosition::Response.parse_string(File.read('test/responses/returnPositionFailure.xml'))
  end
end
