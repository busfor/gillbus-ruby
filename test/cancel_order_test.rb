require 'test_helper'

class CancelOrderTest < Minitest::Test
  def cancel_order
    Gillbus::CancelOrder::Response.parse_string(File.read('test/responses/cancelOrder.xml'))
  end

  def test_cancel_order
    assert cancel_order.order_cancel.confirmation
  end
end
