require 'test_helper'

class FindOrderTest < Minitest::Test

  def find_order
    Gillbus::FindOrder::Response.parse_string(File.read('test/responses/findOrder.xml'))
  end

  def test_number
    assert_equal("14482", find_order.tickets.first.ticket_number)
  end

  def test_total
    assert_equal(Money.new(20_46, 'UAH'), find_order.tickets.first.total_amount)
  end

  def test_status
    assert_equal(:ticketed, find_order.tickets.first.ticket_status)
  end

  def test_return_causes
    assert_equal(Money.new(20_38, 'UAH'), find_order.tickets.first.return_causes.first.approximate_amount)
  end
end
