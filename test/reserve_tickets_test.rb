require 'test_helper'
require 'pry'

class ReserveTicketsTest < Minitest::Test
  def reserve_tickets
    Gillbus::ReserveTickets::Response.parse_string(File.read('test/responses/reserveTickets.xml'))
  end

  def test_number
    assert_equal('8472', reserve_tickets.tickets.first.ticket_number)
  end

  def test_total
    assert_equal(Money.new(110_00, 'UAH'), reserve_tickets.tickets.first.total_amount)
  end

  def test_date_to_pay
    assert_equal(DateTime.new(2013, 5, 22, 20, 30, 0, '+3'), reserve_tickets.tickets.first.date_to_pay)
  end

  def test_date_to_pay_with_timezone
    tickets = Gillbus::ReserveTickets::Response.parse_string(
      File.read('test/responses/reserveTickets.xml'),
      timezone: 'Europe/Moscow',
    )
    assert_equal(DateTime.new(2013, 5, 22, 20, 30, 0, '+4'), tickets.tickets.first.date_to_pay)
    assert_equal('MSK', tickets.tickets.first.date_to_pay.zone)
  end

  def test_working_without_options
    xml = YAML.load(File.read('test/responses/reserveTickets.yml'))
    Gillbus::ReserveTickets::Response.parse(xml) # should not raise error
  end
end
