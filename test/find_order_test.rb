require 'test_helper'

class FindOrderTest < Minitest::Test
  def find_order
    Gillbus::FindOrder::Response.parse_string(File.read('test/responses/findOrder.xml'))
  end

  def find_order2
    Gillbus::FindOrder::Response.parse_string(File.read('test/responses/bookingDifferentCurrencies.xml'))
  end

  def test_number
    assert_equal('14482', find_order.tickets.first.ticket_number)
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

  def test_comission_vat_value
    assert_equal('18', find_order.tickets.last.commissions.first.vat_value)
  end

  def test_vat_value
    assert_equal('0', find_order.tickets.first.vat_value)
  end

  def test_comission_currency
    assert_equal(Money.new(51_55, 'RUB'), find_order2.tickets.last.commissions.last.value)
  end
end
