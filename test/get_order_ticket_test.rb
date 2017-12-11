require 'test_helper'

class GetOrderTicketTest < Minitest::Test
  def get_order_ticket
    Gillbus::GetOrderTicket::Response.parse_string(File.read('test/responses/getOrderTicket.xml'))
  end

  def test_ticket
    assert_equal('base64 string', get_order_ticket.ticket)
  end
end
